import {
  View,
  Text,
  TextInput,
  StyleSheet,
  TextInputProps,
} from "react-native";
import React, { useState } from "react";

type FormInput = {
  label?: string;
} & TextInputProps;

export default function FormInput({ label, ...rest }: FormInput) {
  const [focus, setFocus] = useState(false);

  return (
    <View style={[styles.container, focus && styles.focusContainer]}>
      {label && <Text style={[styles.label, styles.text]}>{label}</Text>}
      <TextInput
        {...rest}
        onFocus={() => setFocus(true)}
        onBlur={() => setFocus(false)}
        style={[styles.input]}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: 4,
    width: "100%",
    borderBottomColor: "grey",
    borderBottomWidth: 1,
  },
  label: {
    fontSize: 13,
  },
  focusContainer: {
    borderBottomColor: "#cdab8f",
  },
  text: {
    color: "#cdab8f",
  },
  input: {
    color: "white",
  },
});
