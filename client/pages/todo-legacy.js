import dynamic from "next/dynamic";
import getConfig from "next/config";
import Header from "../components/Header.bs";

const service_url = getConfig().publicRuntimeConfig.service_url;

const TodoAppLegacy = dynamic(() => import("../components/TodoAppLegacy.bs"), {
  ssr: false,
});

const TodoLegacyPage = () => (
  <>
    <Header />
    <TodoAppLegacy service_url={service_url} />
  </>
);

export default TodoLegacyPage;
