import React from 'react';
import { Row, Col } from 'antd';

import LineChart from './LineChart';

import 'antd/dist/antd.css';


const axios = require('axios').default;

class MachinePage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            loading: true,

            xFieldName: "x",
            yFieldName: "y",
            seriesField: 'type',
            chartDataArray: [
                [
                    {
                        pointsData: [],
                        type: 'cpu',
                        title: "CPU 负载",
                        desc: "按cpu分组的负载率",
                        url: "http://metric.lgxzj.wiki/api/v1/query_range",
                        yAxis: {
                            visible: true,
                            min: 0,
                            max: 110,
                            tickCount: 5,
                        },
                    },
                    {
                        pointsData: [],
                        type: 'mem',
                        title: "内存 负载",
                        desc: "内存资源使用情况，单位MB",
                        url: "http://metric.lgxzj.wiki/api/v1/query_range",
                        yAxis: {
                            visible: true,
                            min: 0,
                            max: 4400,
                            tickCount: 5,
                        },
                    },
                    {
                        pointsData: [],
                        type: 'net_io',
                        title: "网络 IO",
                        desc: "网络收发负载，单位KB",
                        url: "http://metric.lgxzj.wiki/api/v1/query_range",
                        
                    },
                ],
                [
                    {
                        pointsData: [],
                        type: 'disk_io',
                        title: "磁盘 IO",
                        desc: "磁盘读写负载，单位KB",
                        url: "http://metric.lgxzj.wiki/api/v1/query_range",
                        // yAxis: {
                        //     visible: true,
                        //     min: 0,
                        //     max: 1024 * 50,
                        //     tickCount: 5,
                        // },
                    },
                    {
                        pointsData: [
    
                        ],
                        type: 'disk_cap',
                        title: "磁盘 容量",
                        desc: "",
                        url: "",
                    },
                ]
            ],
        };
        this.fetchData           = this.fetchData.bind(this);
        this.fetchCpuData        = this.fetchCpuData.bind(this);
        this.genQueryTimeRange   = this.genQueryTimeRange.bind(this);

        const oneSecond = 3000;
        setInterval(this.fetchData, oneSecond);
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
        row[colIdx].pointsData = data;
        this.setState((preState) => {
            var newState = JSON.parse(JSON.stringify(preState));
            newState.chartDataArray[rowIdx][colIdx].pointsData = data;
            return newState;
        });
    }

    fetchCpuData(row, rowIdx, col, colIdx) {
        let timeRange = this.genQueryTimeRange();
        axios.get(col.url, {
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

        const totalPromise = [];
        inputs.forEach((input) => {
            totalPromise.push(
                axios.get(
                    col.url,
                    {
                        params: {
                            ...timeRange,
                            query: input.query,
                        }
                    })
            )
        });

        Promise.all(totalPromise)
            .then((resArray) => {
                let totalResult = [];

                console.log("resArray", resArray);

                resArray.forEach((res, resIdx) => {
                    var machineResult = this.getResultFromResponse(res);

                    machineResult.forEach((dataEle) => {
                        const cpuDataValues = dataEle.values;
                        
                        cpuDataValues.forEach((point) => {
                            let pointDate = this.unixTimestamp2DateFormat(point[0]);
                            let value = this.stringValue2Int(point[1]);
                            
                            if (unitTranslator != null) {
                                value = unitTranslator(value);
                            }

                            let label = inputs[resIdx].label;
                            if (labelAppender != null) {
                                label += ("_" + labelAppender(dataEle));
                            }

                            totalResult.push(
                                {
                                    [this.state.xFieldName]: pointDate,
                                    [this.state.yFieldName]: value,
                                    [this.state.seriesField]:label,
                                }
                            )
                        })
                    });
                })

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
            (dataEle) => dataEle.metric.device);
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
            }
        ]
        this.fetchDiskIODataParallel(row, rowIdx, col, colIdx, inputs);
    }

    fetchNetworkIOData(row, rowIdx, col, colIdx) {
        const inputs = [
            {
                query:    "irate(node_network_receive_bytes_total[15s])",
                label:    "read",
            },
            {
                query:      "irate(node_network_transmit_bytes_total[15s])",
                label:      "written",
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

    fetchData() {
        this.state.chartDataArray.forEach((row, rowIdx) => {
            row.forEach((col, colIdx) => {
                switch (col.type) {
                    case "cpu":         this.fetchCpuData(row, rowIdx, col, colIdx);        break;
                    case "mem":         this.fetchMemData(row, rowIdx, col, colIdx);        break;
                    case "disk_io":     this.fetchDiskIOData(row, rowIdx, col, colIdx);     break;
                    case "net_io":      this.fetchNetworkIOData(row, rowIdx, col, colIdx);  break;
                    
                    default:        break;
                }
            })
        })
    }

    componentDidMount() {
        this.fetchData();
    }
    componentWillUnmount() {
        
    }

    render() {
        const rows = [];
        for (let i = 0; i < this.state.chartDataArray.length; ++i) {
            const cols = [];
            for (let j = 0; j < this.state.chartDataArray[i].length; ++j) {
                const data = {
                    xFieldName: this.state.xFieldName,
                    yFieldName: this.state.yFieldName,
                    seriesField: this.state.seriesField,
                    pointsData: this.state.chartDataArray[i][j].pointsData,
                    title: this.state.chartDataArray[i][j].title,
                    desc: this.state.chartDataArray[i][j].desc,
                    yAxis: this.state.chartDataArray[i][j].yAxis,
                }

                let colKey = "col_" + i.toString() + "_" + j.toString();
                cols.push(
                    <Col key={colKey} span={8} > 
                        <LineChart {...data} />
                    </Col>
                )
            }

            const rowKey = "row_" + i.toString();
            rows.push(
                <Row key={rowKey} gutter={[16, 16]}>
                    {cols}
                </Row>
            )
        }

        return (
            <div>
                {rows}
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
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

export default MachinePage;