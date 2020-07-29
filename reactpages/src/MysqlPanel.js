import React from 'react';

import MonitorPanel from './MonitorPanel';

class MysqlPanel extends React.Component {
    constructor(props) {
        super(props);

        this.state = this.state = {
            xFieldName: "x",
            yFieldName: "y",
            seriesField: 'type',
            
            chartDataArray: [
                {
                    panelTitle: 'Connections',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'mysql_conn_stats',
                            chartType: 'line',
                            title: "MySQL 连接状态",
                            desc: "打开/当前/最大/峰值 连接",
                            yAxis: {
                                visible: true,
                                min: 0,
                                max: 400,
                                tickCount: 5,
                            },
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'mysql_conn_err',
                            chartType: 'line',
                            title: "MySQL 连接错误数",
                            desc: "MySQL连接错误，按错误分类",
                            yAxis: {
                                visible: true,
                                min: 0,
                                max: 400,
                                tickCount: 5,
                            },
                            loading: true,
                        },                        
                    ],
                },
                {
                    panelTitle: '查询吞吐量',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'mysql_tps_qps',
                            chartType: 'line',
                            title: "MySQL TPS/QPS Summary",
                            desc: "TPS/QPS",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'mysql_command_qps',
                            chartType: 'line',
                            title: "MySQL QPS By Command",
                            desc: "按命令分类QPS",
                            loading: true,
                        },
                    ]
                },
                {
                    panelTitle: '查询性能',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'mysql_query_slow',
                            chartType: 'line',
                            title: "MySQL Slow Query",
                            desc: "慢查询率",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'mysql_slow_threshold',
                            chartType: 'liquid',
                            maxValue: 50,
                            title: "MySQL 慢查询阈值",
                            desc: "慢查询阈值，单位喵",
                            loading: true,
                        },
                    ]
                },
                {
                    panelTitle: 'InnoDB缓存',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'mysql_buffer_pool_size',
                            chartType: 'statistics',
                            title: "MySQL Buffer Pool Size",
                            desc: "InnoDB缓存池大小, 单位KB",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'mysql_buffer_pool_page_size',
                            chartType: 'statistics',
                            title: "MySQL Buffer Pool Page Size",
                            desc: "InnoDB缓存池页面大小, 单位KB",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'mysql_buffer_pool_pages',
                            chartType: 'line',
                            title: "MySQL Buffer Pool Pages",
                            desc: "InnoDB缓存池页面数，按类型分类",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'mysql_buffer_pool_hits',
                            chartType: 'line',
                            title: "MySQL Buffer Pool Hit Status",
                            desc: "InnoDB缓存池页面命中状态",
                            loading: true,
                        },
                    ]
                }
            ],
        };
    }
    


    render() {
        return (
            <MonitorPanel {...this.state} >
            </MonitorPanel>
        );
    }
}

export default MysqlPanel;