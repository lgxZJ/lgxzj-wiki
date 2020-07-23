import React from 'react';
import { Line } from '@ant-design/charts';

class LineChart extends React.Component {
    render() {
        const xFieldName = this.props.xFieldName;
        const yFieldName = this.props.yFieldName;
        const pointsData = this.props.pointsData;
        const chartTitle = this.props.title;
        const chartDesc  = this.props.desc;
        const seriesField = this.props.seriesField;

        const config = {
            title: {
                visible: false,
                text: chartTitle,
            },
            description: {
                visible: true,
                text: chartDesc,
            },
            xField: xFieldName,
            yField: yFieldName,
            seriesField,
            data: pointsData,

            padding: 'auto',
            forceFit: true,
            label: {
                visible: true,
                type: 'point',
            },
            point: {
                visible: true,
                size: 2,
                shape: 'circle',
                style: {
                    fill: 'white',
                    stroke: '#2593fc',
                    lineWidth: 1,
                },
            },
            legend: { position: 'right-top' },
            yAxis: this.props.yAxis,
        };

        return (
            <div>
                <Line {...config} />;
            </div>
        );
    }
}

export default LineChart;