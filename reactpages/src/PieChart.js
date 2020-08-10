import React from 'react';

import { Pie } from '@ant-design/charts';

class PieChart extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            title:  props.chartTitle,
            desc:   props.desc,
            data:   props.data,
        }
    }

    render() {
        const config = {
            forceFit: true,
            title: {
              visible: true,
              text: this.state.title,
            },
            description: {
              visible: true,
              text: this.state.desc,
            },
            radius: 0.8,
            data: this.state.data,
            angleField: 'value',
            colorField: 'type',
            label: {
              visible: true,
              // type: 'outer-center',
              // formatter:  (text, item) => `${item._origin.type}: ${item._origin.value}`,
              type: 'spider',
            },
          };

        return (
            <Pie {...config}>

            </Pie>
        );
    }
}

export default PieChart;