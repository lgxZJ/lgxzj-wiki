import React from 'react';
import { Bullet } from '@ant-design/charts';

class BulletChart extends React.Component {
    render() {
      let target = 85;
      let ranges = [ 0, 0.5, 0.85, 1 ];
      let rangeMax = 100;

      let configData = [];
      this.props.data.forEach(element => {
        configData.push({
          title: element.bulletTitle,
          measures: [element.bulletMeasure],
          targets: [target],
          ranges,
        })
      });
      
      const config = {
          title: {
            visible: true,
            text: this.props.chartTitle,
          },
          description: {
            visible: true,
            text: this.props.chartDesc,
          },
          data: configData,
          rangeMax,
          rangeColors: ['#FFB1AC', '#FFDBA2', '#B4EBBF'],
          // legend: {
          //   custom: true,
          //   items: [
          //     {
          //       name: '实际进度',
          //       marker: {
          //         symbol: 'square',
          //         style: { fill: '#5B8FF9' },
          //       },
          //     },
          //     {
          //       name: '目标值',
          //       marker: {
          //         symbol: 'line',
          //         style: { stroke: '#5B8FF9' },
          //       },
          //     },
          //     {
          //       name: '差',
          //       marker: {
          //         symbol: 'square',
          //         style: { fill: '#FFB1AC' },
          //       },
          //     },
          //     {
          //       name: '良',
          //       marker: {
          //         symbol: 'square',
          //         style: { fill: '#FFDBA2' },
          //       },
          //     },
          //     {
          //       name: '优',
          //       marker: {
          //         symbol: 'square',
          //         style: { fill: '#B4EBBF' },
          //       },
          //     },
          //   ],
          // },
        };

      return (
          <Bullet {...config} />
      )
    }
}

export default BulletChart;