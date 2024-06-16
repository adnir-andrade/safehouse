import { View, Text, Image, StyleSheet } from "react-native";
import React from "react";

export default function Logo() {
  return (
    <View style={styles.container}>
      <Image
        style={styles.logo}
        source={require("../../../assets/images/index-title.png")}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    position: "absolute",
    top: -430,
    left: 0,
    right: 0,
    bottom: 0,
    alignItems: "center",
    justifyContent: "center",
    zIndex: 0,
  },
  logo: {
    width: "100%",
    height: 200,
  },
});
