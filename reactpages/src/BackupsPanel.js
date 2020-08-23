import React from 'react';

import MonitorPanel from './MonitorPanel';

class BackupsPanel extends React.Component {
    constructor(props) {
        super(props);

        this.state = this.state = {
            xFieldName: "x",
            yFieldName: "y",
            seriesField: 'type',
            
            chartDataArray: [
                {
                    panelTitle: 'Backups',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'backup_mysql_size',
                            chartType: 'column',
                            title: "MySQL备份大小",
                            desc: "近七日备份，单位KB",
                            // yAxis: {
                            //     visible: true,
                            //     min: 0,
                            //     max: 110,
                            //     tickCount: 5,
                            // },
                            loading: true,
                        },                        
                    ],
                },
                {
                    panelTitle: 'Backups',
                    chartConfigs: [
                        {
                            queryUrl: "http://metric.lgxzj.wiki/api/v1/query",
                            pointsData: [],
                            type: 'backup_wordpress_size',
                            chartType: 'column',
                            title: "Wordpress备份大小",
                            desc: "近七日备份，单位KB",
                            // yAxis: {
                            //     visible: true,
                            //     min: 0,
                            //     max: 110,
                            //     tickCount: 5,
                            // },
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

export default BackupsPanel;