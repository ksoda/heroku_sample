/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Converted from https://github.com/facebook/react-native/blob/724fe11472cb874ce89657b2c3e7842feff04205/template/App.js
 * With a few tweaks
 */
open ReactNative;

type reactNativeNewAppScreenColors = {
  .
  "primary": string,
  "white": string,
  "lighter": string,
  "light": string,
  "black": string,
  "dark": string,
};

[@bs.module "react-native/Libraries/NewAppScreen"]
external colors: reactNativeNewAppScreenColors = "Colors";

/*
 Here is StyleSheet that is using Style module to define styles for your components
 The main different with JavaScript components you may encounter in React Native
 is the fact that they **must** be defined before being referenced
 (so before actual component definitions)
 More at https://reasonml-community.github.io/reason-react-native/en/docs/apis/Style/
 */
let styles =
  Style.(
    StyleSheet.create({
      "scrollView": style(~backgroundColor=colors##lighter, ()),
      "engine": style(~position=`absolute, ~right=0.->dp, ()),
      "body": style(~backgroundColor=colors##white, ()),
      "sectionContainer":
        style(~marginTop=32.->dp, ~paddingHorizontal=24.->dp, ()),
      "sectionTitle":
        style(~fontSize=24., ~fontWeight=`_600, ~color=colors##black, ()),
      "sectionDescription":
        style(
          ~marginTop=8.->dp,
          ~fontSize=18.,
          ~fontWeight=`_400,
          ~color=colors##dark,
          (),
        ),
      "highlight": style(~fontWeight=`_700, ()),
      "footer":
        style(
          ~color=colors##dark,
          ~fontSize=12.,
          ~fontWeight=`_600,
          ~padding=4.->dp,
          ~paddingRight=12.->dp,
          ~textAlign=`right,
          (),
        ),
    })
  );

module Card = {
  [@react.component]
  let make = (~title, ~children) =>
    <View style=styles##sectionContainer>
      <Text style=styles##sectionTitle> {React.string(title)} </Text>
      <Text style=styles##sectionDescription> children </Text>
    </View>;
};

[@react.component]
let app = () =>
  <>
    <StatusBar barStyle=`darkContent />
    <SafeAreaView>
      <ScrollView
        contentInsetAdjustmentBehavior=`automatic style=styles##scrollView>
        {
          Global.hermesInternal->Belt.Option.isNone ?
            React.null :
            <View style=styles##engine>
              <Text style=styles##footer>
                "Engine: Hermes"->React.string
              </Text>
            </View>
        }
        <View style=styles##body>
          <Card title="Step One">
            "Edit "->React.string
            <Text style=styles##highlight> "src/App.re"->React.string </Text>
            " to change this screen and then come back to see your edits."
            ->React.string
          </Card>
          <Card title="Learn More">
            "Read the docs to discover what to do next:"->React.string
          </Card>
        </View>
      </ScrollView>
    </SafeAreaView>
  </>;