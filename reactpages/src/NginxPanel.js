import React from 'react';

import MonitorPanel from './MonitorPanel';

class NginxPanel extends React.Component {
    constructor(props) {
        super(props);

        this.state = this.state = {
            xFieldName: "x",
            yFieldName: "y",
            seriesField: 'type',
            
            chartDataArray: [
                {
                    panelTitle: 'Wordpress Blog Site',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'nginx_http_req_status_www.lgxzj.wiki',
                            chartType: 'pie',
                            title: "www.lgxzj.wiki请求响应分布",
                            desc: "",
                            loading: true,
                        },                        
                    ],
                },
                {
                    panelTitle: 'React Pages',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'nginx_http_req_status_metric.lgxzj.wiki',
                            chartType: 'pie',
                            title: "metric.lgxzj.wiki请求响应分布",
                            desc: "",
                            loading: true,
                        }, 
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'nginx_http_req_status_react.lgxzj.wiki',
                            chartType: 'pie',
                            title: "react.lgxzj.wiki请求响应分布",
                            desc: "",
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

export default NginxPanel;