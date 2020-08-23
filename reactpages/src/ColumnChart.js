import React from 'react';
import { Column } from '@ant-design/charts';

class ColumnChart extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            ...props
        }
    }

    render() {
        const config = {
            title: {
              visible: true,
              text: this.state.title,
            },
            description: {
              visible: true,
              text: this.state.desc,
            },
            forceFit: true,
            data: this.state.data,
            padding: 'auto',
            xField: 'name',
            yField: 'value',
            // meta: {
            //   type: { alias: '类别' },
            //   sales: { alias: '销售额(万)' },
            // },
            label: {
              visible: true,
              position: 'middle',
            },
        };

        return (
            <Column {...config} />
        );
    }
}

export default ColumnChart;