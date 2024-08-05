import { hapTasks } from '@ohos/hvigor-ohos-plugin';
import { OhosPluginId } from '@ohos/hvigor-ohos-plugin';
// 自定义插件代码
export function setPackage(dependenciesName : string, versionName : string): HvigorPlugin {
    return {
        pluginId: 'customPlugin',
        async apply(currentNode: HvigorNode): Promise<void> {
            const rootNodeContext = currentNode.getContext(OhosPluginId.OHOS_HAP_PLUGIN);
            if (!rootNodeContext) {
                return;
            }
            const dependenciesInfo = rootNodeContext.getDependenciesOpt()
            dependenciesInfo["@qiniu/qplayer2-core"] = versionName
            console.log(`setPackage : ` + dependenciesName + ` version : ` + dependenciesInfo["@qiniu/qplayer2-core"]);
            rootNodeContext.setDependenciesOpt(dependenciesInfo);
        }
    };
}

export default {
    system: hapTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins:[
        // setPackage("ohpm","^1.5.0-preview4")
      setPackage("source","file:../qplayer2_core")
      // setPackage("local","file:./dependency/qplayer2_core.har")
    ]         /* Custom plugin to extend the functionality of Hvigor. */
}
