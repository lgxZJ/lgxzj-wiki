import React from 'react';

import { Tabs } from 'antd';

import 'antd/dist/antd.css';

import MonitorPanel from './MonitorPanel';
import MysqlPanel from './MysqlPanel';
import NginxPanel from './NginxPanel';
import PhpFpmPanel from './PhpFpmPanel';
import PrometheusPanel from './PrometheusPanel';
import BackupsPanel from './BackupsPanel';
import WordpressPanel from './WordpressPanel';

const { TabPane } = Tabs;

class ServicePage extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            dataConfigs: [
                {
                    tabTitle: 'MySQL'
                },
                {
                    tabTitle: 'Nginx'
                },
                {
                    tabTitle: 'PHP-FPM'
                },
                {
                    tabTitle: 'Backups'
                },
            ]
        }
    }

    onTabChange() {

    }

    title2Component(title) {
        switch (title) {
            case "MySQL":       return <MysqlPanel />;
            case "Nginx":       return <NginxPanel />;
            case "PHP-FPM":     return <PhpFpmPanel />;
            case "Prometheus":  return <PrometheusPanel />;
            case "Backups":     return <BackupsPanel />;

            default:    throw "unexpected title:" + title;
        }
    }

    tabPaneKey(idx) {
        return "key_" + idx.toString();
    }

    render() {
        var tabPanes = [];
        this.state.dataConfigs.forEach((ele, idx) => {
            tabPanes.push(
                <TabPane tab={ele.tabTitle} key={this.tabPaneKey(idx)} >
                    { this.title2Component(ele.tabTitle) }
                </TabPane>
            );
        });

        return (
            <Tabs defaultActiveKey={this.tabPaneKey(0)} onChange={this.onTabChange} type={"card"} centered={true}>
                {tabPanes}
            </Tabs>
        )
    }
}


export default ServicePage;