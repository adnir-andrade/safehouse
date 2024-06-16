import { Button, View, StyleSheet } from "react-native";
import React, { useState } from "react";
import HeaderWithTitle from "../components/headers/HeaderWithMenu";
import Background from "../components/ui/Background";
import Card from "../components/containers/Card";
import { useRouter } from "expo-router";
import FormInput from "../components/FormInput";

type Survivor = {
  id?: string;
  name: string;
  age: number;
};

export default function create() {
  const router = useRouter();
  const [name, setName] = useState("");
  const [age, setAge] = useState(0);
  const [gender, setGender] = useState("");
  const [longitude, setLongitude] = useState(0);
  const [latitude, setLatitude] = useState(0);

  const handleNameChange = (name: string) => {
    setName(name);
  };

  const handleAgeChange = (age: number | string) => {
    setAge(Number(age));
  };

  const handleGenderChange = (type: string) => {
    setGender(type);
  };

  const handleSubmit = async () => {
    router.push("/list");
  };

  return (
    <Background>
      <HeaderWithTitle title="Create" />
      <View style={styles.view}>
        <Card>
          <FormInput
            label="Name"
            value={name}
            onChangeText={handleNameChange}
            placeholder="Rick Grimes"
            placeholderTextColor="#999"
          />
          <FormInput
            label="Age"
            value={age.toString()}
            onChangeText={handleAgeChange}
            placeholder="Age"
            keyboardType="numeric"
          />
          <FormInput
            label="Gender"
            value={gender}
            onChangeText={handleGenderChange}
            placeholder="Cat"
            placeholderTextColor="#999"
          />
          <Button title="Submit" onPress={handleSubmit} />
        </Card>
      </View>
    </Background>
  );
}

const styles = StyleSheet.create({
  list: {
    color: "#fff",
  },
  view: {
    margin: 25,
    paddingHorizontal: 400,
  },
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
});
