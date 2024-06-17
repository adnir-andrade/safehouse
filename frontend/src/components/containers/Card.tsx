import { View, StyleSheet } from "react-native";
import React, { PropsWithChildren, useContext } from "react";
import AppContext from "../../contexts/AppContext";

export default function Card({ children }: PropsWithChildren) {
  const app = useContext(AppContext);

  return <View style={[styles.container, { backgroundColor: app!.backgroundColor }]}>{children}</View>;
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 24,
    width: "100%",
    borderRadius: 15,
    opacity: 0.75,
  },
});
