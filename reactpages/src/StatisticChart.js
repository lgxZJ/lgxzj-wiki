import React from 'react';

import { Statistic } from 'antd';

class StatisticChart extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            title: this.props.desc,
            value: this.props.value,
        }
    }

    render() {
        return (
            <Statistic {...this.state} >
            </Statistic>
        );
    }
}

export default StatisticChart;