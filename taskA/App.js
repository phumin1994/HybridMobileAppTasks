import { StatusBar } from 'expo-status-bar';
import React, { useState } from 'react';
import { TouchableOpacity, Text, View } from 'react-native';
import styles from "./style";

const App =() => {

  const [BgColor, setBgcolor] = useState(Array(4).fill('#ed1b24'));  // init state : ['#ed1b24','#ed1b24','#ed1b24','#ed1b24']

  // when button is clicked
  buttonClick = (i) => {
    let tempColor;
    tempColor = BgColor[i] == '#ed1b24' ? 'yellow' : '#ed1b24'
    const bgcol = BgColor.slice()
    bgcol[i] = tempColor
    setBgcolor(bgcol);   // set state with changed value.
  }

  return (
    <View style={styles.container}>
      <View style={styles.buttonGroup}>
        <TouchableOpacity
          style={styles.buttonDiv}
          onPress={() => buttonClick(0)}
        >
          <Text style={styles.appButtonText}>Button 1</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.buttonDiv}
          onPress={() => buttonClick(1)}
        >
          <Text style={styles.appButtonText}>Button 2</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.buttonDiv}
          onPress={() => buttonClick(2)}
        >
          <Text style={styles.appButtonText}>Button 3</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.buttonDiv}
          onPress={() => buttonClick(3)}
        >
          <Text style={styles.appButtonText}>Button 4</Text>
        </TouchableOpacity>
      </View>
      <View style={styles.labelGroup}>
        <Text style={{ ...styles.label, backgroundColor: BgColor[0] }}>BOX 1</Text>
        <Text style={{ ...styles.label, backgroundColor: BgColor[1] }}>BOX 2</Text>
        <Text style={{ ...styles.label, backgroundColor: BgColor[2] }}>BOX 3</Text>
        <Text style={{ ...styles.label, backgroundColor: BgColor[3] }}>BOX 4</Text>
      </View>
      <StatusBar style="auto" />
    </View>
  );
}

export default App;
