import React from 'react';

import MonitorPanel from './MonitorPanel';

class PhpFpmPanel extends React.Component {
    constructor(props) {
        super(props);

        this.state = this.state = {
            xFieldName: "x",
            yFieldName: "y",
            seriesField: 'type',
            
            chartDataArray: [
                {
                    panelTitle: 'Wordpress WorkerPool',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'phpfpm_wordpress_total_conns',
                            chartType: 'statistics',
                            title: "Accepted Conns",
                            desc: "累计连接数",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'phpfpm_wordpress_start_time',
                            chartType: 'statistics',
                            title: "Start Time",
                            desc: "启动时间，单位分钟",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'phpfpm_wordpress_max_active_proc',
                            chartType: 'statistics',
                            title: "最大历史活跃进程数",
                            desc: "",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'phpfpm_wordpress_proc_threshold_times',
                            chartType: 'statistics',
                            title: "进程fork触限次数",
                            desc: "",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'phpfpm_wordpress_process',
                            chartType: 'line',
                            title: "进程池",
                            desc: "进程池进程数量，按状态分类",
                            loading: true,
                        },  
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'phpfpm_wordpress_req_latency',
                            chartType: 'line',
                            title: "请求耗时",
                            desc: "单位毫秒",
                            loading: true,
                        },   
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'phpfpm_wordpress_req_slow',
                            chartType: 'statistics',
                            title: "慢查询次数",
                            desc: "超过request_slowlog_timeout耗时的查询次数",
                            loading: true,
                        },   
                    ],
                },
                {
                    panelTitle: 'Sql WorkerPool',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'phpfpm_sql_total_conns',
                            chartType: 'statistics',
                            title: "Accepted Conns",
                            desc: "累计连接数",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'phpfpm_sql_start_time',
                            chartType: 'statistics',
                            title: "Start Time",
                            desc: "启动时间，单位分钟",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'phpfpm_sql_max_active_proc',
                            chartType: 'statistics',
                            title: "最大历史活跃进程数",
                            desc: "",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'phpfpm_sql_proc_threshold_times',
                            chartType: 'statistics',
                            title: "进程fork触限次数",
                            desc: "",
                            loading: true,
                        },
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'phpfpm_sql_process',
                            chartType: 'line',
                            title: "进程池",
                            desc: "进程池进程数量，按状态分类",
                            loading: true,
                        },  
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'phpfpm_sql_req_latency',
                            chartType: 'line',
                            title: "请求耗时",
                            desc: "单位毫秒",
                            loading: true,
                        },  
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query_range",
                            pointsData: [],
                            type: 'phpfpm_sql_req_slow',
                            chartType: 'statistics',
                            title: "慢查询次数",
                            desc: "超过request_slowlog_timeout耗时的查询次数",
                            loading: true,
                        },   
                    ],
                },
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

export default PhpFpmPanel;