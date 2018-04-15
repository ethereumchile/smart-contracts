pragma solidity ^0.4.17;


contract Chat {

    address public owner;

    struct Message {

        address publisher;
        string text;
        uint date;

    }

    struct Room {

        address owner;
        uint messageCounter;
        Message[] messages;
        bool status;

    }

    mapping(bytes32 => Room) public rooms;

    modifier requireUnique (bytes32 _name) {

        require(!rooms[_name].status && rooms[_name].owner == 0x00);
        _;

    }

    modifier requireRoom (bytes32 _name) {

        require(rooms[_name].status);
        _;

    }

    function Chat () public {

        owner = msg.sender;

    }

    function createRoom (bytes32 _name, string _initialMessage) public requireUnique (_name) {

        Message memory _msg;
        _msg.publisher = msg.sender;
        _msg.text = _initialMessage;
        _msg.date = now;
        rooms[_name].owner = msg.sender;
        rooms[_name].status = true;
        rooms[_name].messages.push(_msg);

    }

    function publishMessage (bytes32 _name, string _message) public requireRoom (_name) {

        Message memory _msg;
        _msg.publisher = msg.sender;
        _msg.text = _message;
        _msg.date = now;
        rooms[_name].messageCounter++;
        rooms[_name].messages.push(_msg);
        
    }

    function lockRoom (bytes32 _name) public {

        require(rooms[_name].owner == msg.sender);
        room[_name].status = !room[_name].status;

    }

}