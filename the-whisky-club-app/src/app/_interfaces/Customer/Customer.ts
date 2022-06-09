export interface Customer{
    name: string,
    lastName1: string,
    lastName2: string,
    userName:string,
    password:string,
    email: string,
    location: string | google.maps.LatLngLiteral
}