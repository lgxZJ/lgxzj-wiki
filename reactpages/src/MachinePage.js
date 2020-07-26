import React from 'react';

import MonitorPage from './MonitorPanel';

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
    }

    render() {
        return (
            <MonitorPage {...this.state} />
        );
    }
}

export default MachinePage;