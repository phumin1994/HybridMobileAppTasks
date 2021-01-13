import { StyleSheet } from 'react-native';

const styles = StyleSheet.create({
    container: {
        flex: 1,
        flexDirection: "row",
        backgroundColor: '#fff',
        alignItems: 'center',
        justifyContent: 'center',
        marginTop: "3%",
        borderStyle: "solid",
        borderColor: "#eee4af",
        borderStyle: "solid",
        borderWidth: 10,
    },
    buttonGroup: {
        backgroundColor: "#c3c3c3",
        justifyContent: "space-around",
        height: "100%",
        width: "50%",
        padding: "auto",
        paddingLeft: 15,
        paddingRight: 15,
    },
    labelGroup: {
        backgroundColor: "#b97a57",
        justifyContent: "space-around",
        height: "100%",
        alignItems: "center",
        width: "50%"
    },
    buttonDiv: {
        height: 50,
        paddingVertical: 20,
        borderColor: "#b3eb02",
        borderRadius: 5,
        borderWidth: 5,
        textAlign: 'center',
        justifyContent: 'center',
        alignItems: 'center'
    },
    appButtonText: {
        fontSize: 15
    },
    label: {
        height: 100,
        width: 130,
        fontSize: 20,
        textAlign: 'center',
        textAlignVertical: 'center'
    }
})

export default styles;