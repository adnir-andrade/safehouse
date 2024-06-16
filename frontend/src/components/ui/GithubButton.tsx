import {
  View,
  TouchableOpacity,
  Image,
  StyleSheet,
  Linking,
} from "react-native";
import React from "react";

export default function GithubButton() {
  return (
    <View style={styles.githubContainer}>
      <TouchableOpacity
        onPress={() => Linking.openURL("https://github.com/adnir-andrade")}
      >
        <Image
          source={require("../../../assets/images/github.png")}
          style={styles.github}
          resizeMode="contain"
        />
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  githubContainer: {
    alignItems: "center",
  },
  github: {
    marginTop: 30,
    height: 80,
    width: 80,
  },
});
