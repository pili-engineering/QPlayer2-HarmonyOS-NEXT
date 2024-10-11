import { hapTasks } from '@ohos/hvigor-ohos-plugin';
import { OhosPluginId } from '@ohos/hvigor-ohos-plugin';
import { hvigor, getNode, HvigorNode  } from '@ohos/hvigor';
// 自定义插件代码
export function setPackage(dependenciesName : string, dependenciesValue : string, sdkVersionOfShow : string): HvigorPlugin {
    return {
        pluginId: 'customPlugin',
        async apply(currentNode: HvigorNode): Promise<void> {
            const rootNodeContext = currentNode.getContext(OhosPluginId.OHOS_HAP_PLUGIN);
            if (!rootNodeContext) {
                return;
            }
            const dependenciesInfo = rootNodeContext.getDependenciesOpt()
            dependenciesInfo["@qiniu/qplayer2-core"] = dependenciesValue
            console.log(`dependenciesName : ` + dependenciesName + ` dependenciesValue : ` + dependenciesInfo["@qiniu/qplayer2-core"]);
            rootNodeContext.setDependenciesOpt(dependenciesInfo);
            const buildProfileOpt = rootNodeContext.getBuildProfileOpt()
            buildProfileOpt["targets"][0]["config"]["buildOption"]["arkOptions"]["buildProfileFields"]["qplayer2_version"] = sdkVersionOfShow
            console.log(`demo version : ` + buildProfileOpt["targets"][0]["config"]["buildOption"]["arkOptions"]["buildProfileFields"]["qplayer2_version"]);
            rootNodeContext.setBuildProfileOpt(buildProfileOpt);
        }
    };
}

export default {
    system: hapTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins:[
        // setPackage("ohpm","^1.5.0-preview4","1.5.0-preview4")
      setPackage("source","file:../qplayer2_core","1.5.0-beta2")
      // setPackage("local","file:./dependency/qplayer2_core.har","1.5.0-preview4")
    ]         /* Custom plugin to extend the functionality of Hvigor. */
}
