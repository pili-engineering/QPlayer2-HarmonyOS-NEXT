
import { appTasks, OhosPluginId, OhosAppContext, AppJson } from '@ohos/hvigor-ohos-plugin';
import { hvigor, getNode, HvigorNode  } from '@ohos/hvigor';

hvigor.nodesEvaluated(() => {
    const node: HvigorNode = getNode(__filename);
    const appContext = node.getContext(OhosPluginId.OHOS_APP_PLUGIN) as OhosAppContext;
    const appJson5: AppJson.AppOptObj = appContext.getAppJsonOpt();

    let date = new Date();
    let currentTime = date.toLocaleString('zh-cn');

    appJson5.app.vendor = currentTime;

    appContext.setAppJsonOpt(appJson5);
});

export default {
    system: appTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins:[]         /* Custom plugin to extend the functionality of Hvigor. */
}
