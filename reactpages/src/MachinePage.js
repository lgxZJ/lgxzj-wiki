import React from 'react';
import { Row, Col } from 'antd';

import LineChart from './LineChart';

import 'antd/dist/antd.css';


const axios = require('axios').default;

class MachinePage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            loading: true,

            xFieldName: "x",
            yFieldName: "y",
            chartDataArray: [
                [
                    {
                        pointsData: [
    
                        ],
                        title: "CPU 负载",
                        desc: "",
                        url: "http://localhost:9090/api/v1/query_range",
                    },
                    {
                        pointsData: [
    
                        ],
                        title: "内存 负载",
                        desc: "",
                        url: "",
                    },
                    {
                        pointsData: [
    
                        ],
                        title: "网络 IO",
                        desc: "",
                        url: "",
                    },
                ],
                [
                    {
                        pointsData: [
    
                        ],
                        title: "磁盘 IO",
                        desc: "",
                        url: "",
                    },
                    {
                        pointsData: [
    
                        ],
                        title: "磁盘 容量",
                        desc: "",
                        url: "",
                    },
                ]
            ],
        };
        this.fetchData = this.fetchData.bind(this);
    }

    fetchData() {
        this.state.chartDataArray.forEach((row, rowIdx) => {
            row.forEach((col, colIdx) => {
                
                const timestampEnd = Math.floor(Date.now() / 1000);
                const timestampStart = timestampEnd - 5;
                axios.get(col.url, {
                    params: {
                        start:  timestampStart,
                        end:    timestampEnd,
                        step:   "1s",
                        query:  "100-(sum(node_cpu_seconds_total{mode=\"idle\"})/sum(node_cpu_seconds_total))*100"
                    }
                })
                    .then( (res) => {
                        console.log(res);
                        var machineResult = res.data.result.filter((ele) => ele.metric.job === "node_exporter");
                        var machineDataPrometheus = machineResult[0].values;

                        const machineDataChart = [];
                        machineDataPrometheus.forEach((point) => {
                            machineDataChart.push(
                                {
                                    [this.state.xFieldName]: point[0],
                                    [this.state.yFieldName]: point[1]
                                }
                            )
                        })
                        row[colIdx].pointsData = machineDataChart;

                        this.setState((preState) => {
                            var newState = JSON.parse(JSON.stringify(preState));
                            newState.chartDataArray[rowIdx][colIdx].pointsData = machineDataChart;
                            return newState;
                        })
                    })
                    .catch((err) => {
                        console.log("get node metrics failed", err);
                    });
            })
        })

        axios.get()
            .then( res => {

            } )
            .catch( error => {

            });
    }

    componentDidMount() {
        this.fetchData();
    }
    componentWillUnmount() {
        
    }

    render() {

        const rows = [];
        for (let i = 0; i < this.state.chartDataArray.length; ++i) {
            const cols = [];
            for (let j = 0; j < this.state.chartDataArray[i].length; ++j) {
                const data = {
                    xFieldName: this.state.xFieldName,
                    yFieldName: this.state.yFieldName,
                    pointsData: this.state.chartDataArray[i][j].pointsData,
                    title: this.state.chartDataArray[i][j].title,
                    desc: this.state.chartDataArray[i][j].desc,
                }

                let colKey = "col_" + i.toString() + "_" + j.toString();
                cols.push(
                    <Col key={colKey} span={8} > 
                        <LineChart {...data} />
                    </Col>
                )
            }

            const rowKey = "row_" + i.toString();
            rows.push(
                <Row key={rowKey} gutter={[16, 16]}>
                    {cols}
                </Row>
            )
        }

        return (
            <div>
                {rows}
            </div>
        );
    }
}

export default MachinePage;