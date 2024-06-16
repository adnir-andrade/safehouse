import { StyleSheet, ImageBackground } from "react-native";
import React, { ReactNode, useContext } from "react";
import AppContext from "../../contexts/AppContext";

type BackgroundProps = {
  children: ReactNode;
};

export default function Background({ children }: BackgroundProps) {
  const app = useContext(AppContext);
  const source_light = require("../../../assets/images/background.jpg");
  const source_dark = require("../../../assets/images/background_dark.jpg");
  const logo = app!.isEnabled ? source_light : source_dark;

  return (
    <ImageBackground source={logo} style={styles.background}>
      {children}
    </ImageBackground>
  );
}

const styles = StyleSheet.create({
  background: {
    width: "100%",
    height: "100%",
  },
});
