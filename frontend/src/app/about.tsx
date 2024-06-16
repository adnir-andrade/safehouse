import { View, Text, StyleSheet } from "react-native";
import React, { useContext } from "react";
import HeaderWithTitle from "../components/headers/HeaderWithMenu";
import Background from "../components/ui/Background";
import Card from "../components/containers/Card";
import GithubButton from "../components/ui/GithubButton";
import AppContext from "../contexts/AppContext";

export default function about() {
  const app = useContext(AppContext);

  return (
    <Background>
      <View style={styles.mainContainer}>
        <HeaderWithTitle title="Safehouse" />

        <Card>
          <View style={[styles.container, styles.firstContainer]}>
            <Text style={[styles.title, { color: app!.textColor }]}>
              The Safehouse
            </Text>
          </View>

          <View style={styles.container}>
            <Text style={[styles.subtitle, { color: app!.textColor }]}>
              Developed By
            </Text>
            <Text style={[styles.title, { color: app!.textColor }]}>
              Adnir Andrade
            </Text>
          </View>
          <GithubButton />
        </Card>
      </View>
    </Background>
  );
}

const styles = StyleSheet.create({
  mainContainer: {
    margin: 30,
  },
  firstContainer: {
    marginTop: 45,
  },
  container: {
    marginBottom: 40,
    alignContent: "center",
  },
  title: {
    fontSize: 32,
    textAlign: "center",
  },
  subtitle: {
    fontSize: 16,
    textAlign: "center",
    // color: "#bf9370",
  },
});
