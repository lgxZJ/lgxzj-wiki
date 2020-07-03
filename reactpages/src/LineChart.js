import React from 'react';
import { Line } from '@ant-design/charts';

class LineChart extends React.Component {
    render() {
        const xFieldName = this.props.xFieldName;
        const yFieldName = this.props.yFieldName;
        const pointsData = this.props.pointsData;
        const chartTitle = this.props.title;
        const chartDesc  = this.props.desc;

        const config = {
            title: {
                visible: true,
                text: chartTitle,
            },
            description: {
                visible: true,
                text: chartDesc,
            },
            xField: xFieldName,
            yField: yFieldName,
            data: pointsData,

            padding: 'auto',
            forceFit: true,
            label: {
                visible: true,
                type: 'point',
            },
            point: {
                visible: true,
                size: 5,
                shape: 'diamond',
                style: {
                    fill: 'white',
                    stroke: '#2593fc',
                    lineWidth: 2,
                },
            },
        };

        return (
            <div>
                <Line {...config} />;
            </div>
        );
    }
}

export default LineChart;