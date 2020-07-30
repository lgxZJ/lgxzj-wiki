import React from 'react';

import { Liquid } from '@ant-design/charts';

class LiquidChart extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            curValue: props.curValue,
            maxValue: props.maxValue,
            desc: props.desc,
        }
    }

    render() {
        const config = {
            description: {
              visible: true,
              text: this.state.desc,
            },
            min: 0,
            max: this.state.maxValue,
            value: this.state.curValue,
        };

        return (
            <Liquid {...config} ></Liquid>
        );
    }
}

export default LiquidChart;