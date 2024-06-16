import { Button, View, StyleSheet } from "react-native";
import React, { useState } from "react";
import HeaderWithTitle from "../components/headers/HeaderWithMenu";
import Background from "../components/ui/Background";
import Card from "../components/containers/Card";
import FormInput from "../components/FormInput";
import { useRouter } from "expo-router";

type Survivor = {
  id?: string;
  name: string;
  age: number;
  gender: string;
  is_alive: string;
};

export default function update() {
  const router = useRouter();
  const [name, setName] = useState("");
  const [age, setAge] = useState(0);
  const [gender, setGender] = useState("");

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
      <HeaderWithTitle title="Update" />
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
            placeholderTextColor="#999"
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
});
