import React from 'react';
import { Row, Col,Spin, Collapse, Card } from 'antd';

import LineChart from './LineChart';
import BulletChart from './BulletChart';

import 'antd/dist/antd.css';
import './MachinePage.css';

const { Panel } = Collapse;
const axios = require('axios').default;

class MachinePage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            xFieldName: "x",
            yFieldName: "y",
            seriesField: 'type',
            
            chartDataArray: [
                {
                    panelTitle: 'Cpu & Mem',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'cpu',
                            chartType: 'line',
                            title: "CPU 负载",
                            desc: "按cpu分组的负载率",
                            yAxis: {
                                visible: true,
                                min: 0,
                                max: 110,
                                tickCount: 5,
                            },
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'mem',
                            chartType: 'line',
                            title: "内存 负载",
                            desc: "内存资源使用情况，单位MB",
                            yAxis: {
                                visible: true,
                                min: 0,
                                max: 4400,
                                tickCount: 5,
                            },
                            loading: true,
                        },
                        
                    ],
                },
                {
                    panelTitle: 'Network',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'net_io',
                            chartType: 'line',
                            title: "网络 IO",
                            desc: "网络收发负载，单位KB",
                            loading: true,
                        },
                    ],
                },
                {
                    panelTitle: 'Disk IO & Caps',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'disk_io',
                            chartType: 'line',
                            title: "磁盘 IO",
                            desc: "磁盘读写负载，单位KB",
                            // yAxis: {
                            //     visible: true,
                            //     min: 0,
                            //     max: 1024 * 50,
                            //     tickCount: 5,
                            // },
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'disk_cap',
                            chartType: 'line',
                            title: "磁盘 容量",
                            desc: "磁盘使用情况，单位GB",
                            yAxis: {
                                visible: true,
                                min: 0,
                                max: 100,
                                tickCount: 5,
                            },
                            loading: true,
                        },
                        
                    ],
                },
                {
                    panelTitle: 'Proc Intensives',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'proc_top_cpu',
                            chartType: 'bullet',
                            title: "CPU活跃TOP10",
                            desc: "CPU活跃进程，单位百分比",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'proc_top_mem',
                            chartType: 'bullet',
                            title: "MEM活跃TOP10",
                            desc: "CPU活跃进程，单位百分比",
                            loading: true,
                        }
                    ]
                },
                
            ],
        };
        this.fetchData           = this.fetchData.bind(this);
        this.fetchCpuData        = this.fetchCpuData.bind(this);
        this.genQueryTimeRange   = this.genQueryTimeRange.bind(this);
    }

    genQueryTimeRange() {
        const timestampEnd = Math.floor(Date.now() / 1000);
        const timestampStart = timestampEnd - 5;

        return {
            start:  timestampStart,
            end:    timestampEnd,
            step:   "1s",
        };
    }

    rowIdx2Key(idx) {
        return "row_" + idx.toString();
    }

    unixTimestamp2DateFormat(timestamp) {
        return new Date(timestamp * 1000).Format("HH:mm:ss");
    }

    stringValue2Int(strValue) {
        return parseInt(strValue);
    }

    getResultFromResponse(res) {
         return res.data.data.result;
    }

    updateChartData2State(row, rowIdx, col, colIdx, data) {
        //row[colIdx].pointsData = data;
        this.setState((preState) => {
            var newState = JSON.parse(JSON.stringify(preState));
            const ele = newState.chartDataArray[rowIdx].chartConfigs[colIdx];
            ele.pointsData = data;
            ele.loading = false;
            return newState;
        });
    }

    updateChartLoading2State(row, rowIdx, col, colIdx, loading) {
        this.setState((preState) => {
            var newState = JSON.parse(JSON.stringify(preState));
            newState.chartDataArray[rowIdx].chartConfigs[colIdx].loading = loading;
            return newState;
        });
    }

    fetchCpuData(row, rowIdx, col, colIdx) {
        let timeRange = this.genQueryTimeRange();
        let url = this.state.chartDataArray[rowIdx].chartConfigs[colIdx].queryUrl;

        this.updateChartLoading2State(row, rowIdx, col, colIdx, true);

        axios.get(url, {
            params: {
                ...timeRange,
                query:  "100 - (irate(node_cpu_seconds_total{mode=\"idle\"}[15s]) * 100)"
            }
        })
            .then( (res) => {
                var machineResult = this.getResultFromResponse(res);

                const machineDataChart = [];
                machineResult.forEach((cpuData, cpuIdx) => {
                    const cpuDataValues = cpuData.values;
                    const cpuName = cpuData.metric.cpu;
                    
                    cpuDataValues.forEach((point) => {
                        let pointDate = this.unixTimestamp2DateFormat(point[0]);
                        const cpuUsage = this.stringValue2Int(point[1]);
                        machineDataChart.push(
                            {
                                [this.state.xFieldName]: pointDate,
                                [this.state.yFieldName]: cpuUsage,
                                [this.state.seriesField]:"cpu" + cpuName,
                            }
                        )
                    })
                    
                });

                this.updateChartData2State(row, rowIdx, col, colIdx, machineDataChart);
            })
            .catch((err) => {
                console.log("get node metrics failed", err);
            });
    }



    fetchDataParallel(row, rowIdx, col, colIdx, inputs, unitTranslator, labelAppender) {
        let timeRange = this.genQueryTimeRange();
        const item = this.state.chartDataArray[rowIdx].chartConfigs[colIdx];
        let url = item.queryUrl;

        let loading  = true;
        this.updateChartLoading2State(row, rowIdx, col, colIdx, loading);

        const totalPromise = [];
        inputs.forEach((input) => {
            totalPromise.push(
                axios.get(
                    url,
                    {
                        params: {
                            ...timeRange,
                            query: input.query,
                        }
                    })
            )
        });

        const eleProcessor = (dataEle, resIdx, proc, pointDate, value) => {
            if (unitTranslator != null) {
                value = unitTranslator(value);
            }

            let label = inputs[resIdx].label;
            if (labelAppender != null) {
                let appendLabelPart = labelAppender(dataEle)
                if (appendLabelPart != null) {
                    label += ("_" + appendLabelPart);
                }
            }
            
            switch (item.type) {
                case 'proc_top_mem':
                case 'proc_top_cpu':
                    return {
                            bulletTitle: proc,
                            bulletMeasure: value,
                    };
                    
                default:
                    return {
                            [this.state.xFieldName]: pointDate,
                            [this.state.yFieldName]: value,
                            [this.state.seriesField]:label,
                    };
            }
        }

        Promise.all(totalPromise)
            .then((resArray) => {
                let totalResult = [];

                resArray.forEach((res, resIdx) => {
                    var machineResult = this.getResultFromResponse(res);
                    

                    machineResult.forEach((dataEle) => {
                        if (item.type === 'proc_top_cpu' || item.type === 'proc_top_mem') {
                            const proc = dataEle.metric.proc;
                            let pointDate = this.unixTimestamp2DateFormat(dataEle.value[0]);
                            let value = parseFloat(dataEle.value[1]);

                            totalResult.push(eleProcessor(dataEle, resIdx, proc, pointDate, value));
                        } else {
                            const itemDataValues = dataEle.values;
                            const proc = null;
                            
                            itemDataValues.forEach((point) => {
                                let pointDate = this.unixTimestamp2DateFormat(point[0]);
                                let value = this.stringValue2Int(point[1]);
                                
                                totalResult.push(eleProcessor(dataEle, resIdx, proc, pointDate, value));
                            });
                        }
                    });
                })

                if (item.type === 'proc_top_cpu' || item.type === 'proc_top_mem') {
                    console.log("before update", totalResult);
                    totalResult.sort((ele1, ele2) => {
                        return parseInt(ele2.bulletMeasure) - parseInt(ele1.bulletMeasure);
                    });
                    // if (totalResult.length < 10) {
                    //     let j = 0;
                    //     let len = 10 - totalResult.length;
                    //     for (j = 0; j < len; ++j) {
                    //         totalResult.push({
                    //             bulletTitle: '无',
                    //             bulletMeasure: 0,
                    //         });
                    //     }
                    // }
                    console.log("after update", totalResult);
                }
                
                
                this.updateChartData2State(row, rowIdx, col, colIdx, totalResult);
            })
            .catch((err) => {
                console.log("get metrics failed", err);
            });
    }

    fetchMemDataParallel(row, rowIdx, col, colIdx, inputs) {
        this.fetchDataParallel(
            row, 
            rowIdx, 
            col, 
            colIdx, 
            inputs, 
            (value) => Math.floor(value / 1024 / 1024),
            null);
    }

    fetchMemData(row, rowIdx, col, colIdx) {
        let machineDataChart = [];

        const inputs = [
            {
                query:    "node_memory_MemTotal_bytes",
                label:    "mem_total",
            },
            {
                query:      "node_memory_MemFree_bytes",
                label:      "mem_free",
            }
        ]
        this.fetchMemDataParallel(row, rowIdx, col, colIdx, inputs, machineDataChart);
    }

    fetchDiskIODataParallel(row, rowIdx, col, colIdx, inputs) {
        this.fetchDataParallel(
            row, 
            rowIdx, 
            col, 
            colIdx, 
            inputs, 
            null,
            (dataEle) => {
                if (dataEle.metric.device != null) {
                    return dataEle.metric.device;
                }
                return null;
            });
    }

    fetchDiskIOData(row, rowIdx, col, colIdx) {
        const inputs = [
            {
                query:    "irate(node_disk_written_bytes_total[15s])",
                label:    "written",
            },
            {
                query:      "irate(node_disk_read_bytes_total[15s])",
                label:      "read",
            },
            {
                query:      "irate(node_textfile_scrape_error[15s])",
                label:      "open_err",
            },
        ]
        this.fetchDiskIODataParallel(row, rowIdx, col, colIdx, inputs);
    }

    fetchNetworkIOData(row, rowIdx, col, colIdx) {
        const inputs = [
            {
                query:    "irate(node_network_receive_bytes_total[15s])",
                label:    "recv",
            },
            {
                query:    "irate(node_network_receive_errs_total[15s])",
                label:    "recv_err",
            },
            {
                query:      "irate(node_network_transmit_bytes_total[15s])",
                label:      "sent",
            },
            {
                query:      "irate(node_network_transmit_errs_total[15s])",
                label:      "sent_err",
            }
        ]

        this.fetchDataParallel(
            row, 
            rowIdx, 
            col, 
            colIdx, 
            inputs, 
            (value) => Math.floor(value / 1024),
            (dataEle) => dataEle.metric.device
        );
    }

    fetchProcCpuTopData(row, rowIdx, col, colIdx) {
        const inputs = [
            {
                query:    "ps_pusher_cpu",
                label:    "",
            }
        ];
        this.fetchDataParallel(
            row, 
            rowIdx, 
            col, 
            colIdx, 
            inputs, 
            (value) => value,
            null
        );
    }

    fetchProcMemTopData(row, rowIdx, col, colIdx) {
        const inputs = [
            {
                query:    "ps_pusher_mem",
                label:    "",
            }
        ];
        this.fetchDataParallel(
            row, 
            rowIdx, 
            col, 
            colIdx, 
            inputs, 
            (value) => value,
            null
        );
    }

    fetchDiskCapacityData(row, rowIdx, col, colIdx) {
        const inputs = [
            {
                query:    "node_filesystem_size_bytes",
                label:    "size_total",
            },
            {
                query:    "node_filesystem_size_bytes-node_filesystem_avail_bytes",
                label:    "size_used",
            },
            
        ]

        this.fetchDataParallel(
            row, 
            rowIdx, 
            col, 
            colIdx, 
            inputs, 
            (value) => Math.floor(value / 1024 / 1024 / 1024),
            (dataEle) => { return dataEle.metric.device;}
        );
    }

    fetchData() {
        this.state.chartDataArray.forEach((rowObj, rowIdx) => {
            const row = rowObj.chartConfigs;
            row.forEach((col, colIdx) => {
                switch (col.type) {
                    case "cpu":         this.fetchCpuData(row, rowIdx, col, colIdx);            break;
                    case "mem":         this.fetchMemData(row, rowIdx, col, colIdx);            break;
                    case "disk_io":     this.fetchDiskIOData(row, rowIdx, col, colIdx);         break;
                    case "disk_cap":    this.fetchDiskCapacityData(row, rowIdx, col, colIdx);   break;
                    case "net_io":      this.fetchNetworkIOData(row, rowIdx, col, colIdx);      break;
                    
                    case 'proc_top_cpu':this.fetchProcCpuTopData(row, rowIdx, col, colIdx);     break;
                    case 'proc_top_mem':this.fetchProcMemTopData(row, rowIdx, col, colIdx);     break;
                    
                    default:        break;
                }
            })
        })
    }

    componentDidMount() {
        this.fetchData();

        const oneSecond = 3000;
        setInterval(this.fetchData, oneSecond);
    }
    componentWillUnmount() {
        
    }

    render() {
        const rowPanels = [];
        for (let i = 0; i < this.state.chartDataArray.length; ++i) {
            const cols = [];

            const chartConfigRow = this.state.chartDataArray[i].chartConfigs;
            const panelTitle = this.state.chartDataArray[i].panelTitle;
            for (let j = 0; j < chartConfigRow.length; ++j) {
                let colKey = "col_" + i.toString() + "_" + j.toString();
                let chartData = chartConfigRow[j];

                if (chartData.chartType === 'line') {
                    const data = {
                        xFieldName: this.state.xFieldName,
                        yFieldName: this.state.yFieldName,
                        seriesField: this.state.seriesField,
                        pointsData: chartData.pointsData,
                        title: chartData.title,
                        desc: chartData.desc,
                        yAxis: chartData.yAxis,
                    }
    
                    
                    cols.push(
                        <Col key={colKey} span={12} > 
                            <Card title={chartData.title}>
                                { chartData.loading ? <Spin><LineChart {...data} /></Spin> : <LineChart {...data} /> }
                            </Card>
                            
                        </Col>
                    );
                }
                if (chartData.chartType === 'bullet') {
                    const config = {
                        data: chartData.pointsData,
                        chartTitle: chartData.title,
                        chartDesc: chartData.desc,
                    };
                    cols.push(
                        <Col key={colKey} span={12} > 
                            <Card title={chartData.title}>
                                { chartData.loading ? <Spin><BulletChart {...config} /></Spin> : <BulletChart {...config} /> }
                            </Card>    
                        </Col>
                    )
                }
            
            }

            const rowKey = this.rowIdx2Key(i);
            rowPanels.push(
                <Panel header={panelTitle} key={rowKey}>
                    <Row key={rowKey} gutter={[16, 16]}>
                        {cols}
                    </Row>
                </Panel>
            )
        }

        return (
            <div>
                <Collapse defaultActiveKey={[this.rowIdx2Key(0)]} >
                    {rowPanels}
                </Collapse>
                
            </div>
        );
    }
}

// 对Date的扩展，将 Date 转化为指定格式的String
// 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
// 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
// 例子： 
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
Date.prototype.Format = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "H+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

export default MachinePage;