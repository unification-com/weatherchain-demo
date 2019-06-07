pragma solidity >=0.5.0;

contract WeatherOracle {
  mapping(address => bool) oracleAddresses;

  modifier onlyOracle() {
      require(oracleAddresses[msg.sender] == true);
      _;
  }

  constructor (address[] memory _oracleAddresses) public {
    for (uint i=0; i<_oracleAddresses.length; i++) {
        oracleAddresses[_oracleAddresses[i]] = true;
    }
  }

  event WeatherUpdate (
    string weatherDescription,
    string temperature,
    string humidity,
    string visibility,
    string pressure,
    string sunrise,
    string sunset
  );

  function updateWeather (
    string memory weatherDescription,
    string memory temperature,
    string memory humidity,
    string memory visibility,
    string memory pressure,
    string memory sunrise,
    string memory sunset
  )
  public onlyOracle
  {
    emit WeatherUpdate (
      weatherDescription,
      temperature,
      humidity,
      visibility,
      pressure,
      sunrise,
      sunset
    );
  }
}
