import {
  ActionSheetProvider,
  connectActionSheet,
} from "@expo/react-native-action-sheet";
import { Stack } from "expo-router";
import React, { useState } from "react";
import AppContext from "../contexts/AppContext";

function _layout() {
  const [isEnabled, setIsEnabled] = useState(true);
  const toggleSwitch = () => setIsEnabled(previousState => !previousState);

  const backgroundColor = isEnabled ? "#cdab8f" : "black";
  const textColor = isEnabled ? "black" : "#d5b8a1";

  return (
    <AppContext.Provider value={{isEnabled, toggleSwitch, backgroundColor, textColor}}>
      <ActionSheetProvider>
        <Stack />
      </ActionSheetProvider>
    </AppContext.Provider>
  );
}

const ConnectedApp = connectActionSheet(_layout);

export default ConnectedApp;
