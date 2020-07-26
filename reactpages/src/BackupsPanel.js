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