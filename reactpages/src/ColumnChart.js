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
            description: {
              visible: true,
              text: this.state.desc,
            },
            forceFit: true,
            data: this.state.data,
            padding: 'auto',
            xField: 'name',
            yField: 'value',
            meta: {
              name: { alias: '备份' },
              value: { alias: '值' },
            },
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