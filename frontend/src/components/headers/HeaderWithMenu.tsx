import {
  ImageBackground,
  StyleSheet,
  Switch,
  TouchableOpacity,
  View,
} from "react-native";
import React, { useContext, useState } from "react";
import { Stack } from "expo-router";
import { Ionicons } from "@expo/vector-icons";
import { useActionSheet } from "@expo/react-native-action-sheet";
import { useRouter, useNavigation } from "expo-router";
import AppContext from "../../contexts/AppContext";

type HeaderWithTitleProps = {
  title: string;
};

export default function HeaderWithMenu({ title }: HeaderWithTitleProps) {
  const app = useContext(AppContext);

  const { showActionSheetWithOptions } = useActionSheet();
  const router = useRouter();
  const navigation = useNavigation();

  const options = ["About", "Create", "Read", "Update", "Delete", "Logout"];
  const destructiveButtonIndex = options.indexOf("Logout");

  const handleOpen = () => {
    showActionSheetWithOptions(
      {
        options,
        destructiveButtonIndex,
      },
      (buttonIndex) => {
        if (buttonIndex === options.indexOf("About")) router.push("/about");
        if (buttonIndex === options.indexOf("Create")) router.push("/create");
        if (buttonIndex === options.indexOf("Read")) router.push("/list");
        if (buttonIndex === options.indexOf("Update")) router.push("/update");
        if (buttonIndex === options.indexOf("Delete"))
          router.push("/survivorDelete");

        if (buttonIndex === options.indexOf("Logout")) {
          navigation.reset({
            index: 0,
            // @ts-ignore
            routes: [{ name: "index" }],
          });
        }
      }
    );
  };

  const source_light = require("../../../assets/images/logo.png");
  const source_dark = require("../../../assets/images/logo.png");
  const logo = app!.isEnabled ? source_light : source_dark;

  return (
    <Stack.Screen
      options={{
        headerShown: true,
        headerBackground: () => (
          <ImageBackground
            source={logo}
            style={[
              styles.background,
              { backgroundColor: app!.backgroundColor },
            ]}
            resizeMode="contain"
          />
        ),
        title,
        headerRight: () => (
          <View style={styles.headerRightContainer}>
            <Switch
              trackColor={{ false: "#767577", true: "#81b0ff" }}
              thumbColor={app!.isEnabled ? "#f5dd4b" : "#f4f3f4"}
              ios_backgroundColor="#3e3e3e"
              onValueChange={app!.toggleSwitch}
              value={app!.isEnabled}
            />
            <TouchableOpacity style={styles.menuIcon} onPress={handleOpen}>
              <Ionicons name="menu-outline" size={24} color={app!.textColor} />
            </TouchableOpacity>
          </View>
        ),
        headerTitleStyle: {
          color: app!.textColor,
        },
        headerTintColor: app!.textColor,
      }}
    ></Stack.Screen>
  );
}

const styles = StyleSheet.create({
  header: {
    backgroundColor: "#cdab8f",
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    paddingVertical: 10,
    paddingHorizontal: 20,
  },
  menuIcon: {
    padding: 5,
  },
  background: {
    height: "100%",
    opacity: 0.9,
    backgroundColor: "black",
  },
  headerRightContainer: {
    flexDirection: "row",
    alignItems: "center",
  },
});
