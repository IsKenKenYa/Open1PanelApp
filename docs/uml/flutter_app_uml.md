# Flutter App UML Diagrams for 1Panel Mobile App

## 1. Class Diagram

```mermaid
classDiagram
    AppClient <|-- AuthManager
    AppClient <|-- ApiClient
    AppClient <|-- DataManager
    AppClient <|-- UIManager
    AppClient <|-- CacheManager
    AppClient <|-- WebSocketService
    
    class AppClient {
        +String baseUrl
        +String apiKey
        +initialize()
        +run()
    }
    
    class AuthManager {
        +String token
        +String refreshToken
        +login(username, password)
        +logout()
        +refreshToken()
        +generateAuthHeaders()
        +validateToken()
    }
    
    class ApiClient {
        +AuthManager authManager
        +Dio dio
        +getDashboardOverview()
        +getAppList()
        +installApp(request)
        +uninstallApp(id)
        +getContainerList()
        +startContainer(id)
        +stopContainer(id)
        +getWebsiteList()
        +createWebsite(request)
        +deleteWebsite(id)
        +getFileList(path)
        +uploadFile(path, file)
        +downloadFile(path)
        +deleteFile(path)
        +getBackupList()
        +createBackup(request)
        +restoreBackup(id)
    }
    
    class DataManager {
        +DashboardOverview dashboardOverview
        +List~App~ apps
        +List~Container~ containers
        +List~Website~ websites
        +List~FileInfo~ files
        +List~Backup~ backups
        +loadDashboardData()
        +loadAppData()
        +loadContainerData()
        +loadWebsiteData()
        +loadFileData(path)
        +loadBackupData()
        +updateData()
    }
    
    class UIManager {
        +showDashboard()
        +showAppManager()
        +showContainerManager()
        +showWebsiteManager()
        +showFileManager()
        +showBackupManager()
        +showSettings()
    }
    
    class CacheManager {
        +Map~String, CacheEntry~ cache
        +Duration cacheDuration
        +get(key)
        +put(key, data)
        +remove(key)
        +clear()
        +isExpired(key)
    }
    
    class WebSocketService {
        +IOWebSocketChannel channel
        +StreamController streamController
        +connect()
        +disconnect()
        +send(data)
        +subscribe(topic)
        +unsubscribe(topic)
    }
    
    class DashboardOverview {
        +SystemInfo system
        +CpuInfo cpu
        +MemoryInfo memory
        +DiskInfo disk
        +NetworkInfo network
    }
    
    class SystemInfo {
        +String hostname
        +String os
        +String kernel
        +String uptime
    }
    
    class CpuInfo {
        +double usage
        +int cores
        +String model
    }
    
    class MemoryInfo {
        +double usage
        +int total
        +int available
    }
    
    class DiskInfo {
        +double usage
        +int total
        +int available
    }
    
    class NetworkInfo {
        +int bytesReceived
        +int bytesSent
    }
    
    class App {
        +int id
        +String name
        +String key
        +String version
        +String status
        +String description
        +String icon
        +DateTime installTime
        +int port
        +String index
        +start()
        +stop()
        +restart()
        +update()
        +uninstall()
    }
    
    class Container {
        +String id
        +String name
        +String image
        +String status
        +String state
        +DateTime created
        +List~String~ ports
        +Map~String, String~ labels
        +start()
        +stop()
        +restart()
        +delete()
    }
    
    class Website {
        +int id
        +String primaryDomain
        +List~String~ otherDomains
        +String alias
        +String sitePath
        +String type
        +String status
        +bool ssl
        +DateTime createTime
        +DateTime updateTime
        +enableSSL()
        +disableSSL()
        +delete()
    }
    
    class FileInfo {
        +String name
        +String path
        +bool isDir
        +int size
        +DateTime modifyTime
        +String permission
        +upload(file)
        +download()
        +delete()
    }
    
    class Backup {
        +int id
        +String name
        +String type
        +String status
        +String path
        +DateTime createTime
        +int size
        +String description
        +restore()
        +delete()
    }
    
    class CacheEntry {
        +dynamic data
        +DateTime expiryTime
        +isExpired()
    }
```

## 2. Sequence Diagram - App Installation

```mermaid
sequenceDiagram
    participant User
    participant UIManager
    participant DataManager
    participant ApiClient
    participant AuthManager
    participant CacheManager
    participant 1PanelAPI
    
    User->>UIManager: Select app to install
    UIManager->>DataManager: installApp(request)
    DataManager->>CacheManager: Check cache
    CacheManager-->>DataManager: Cache data (if available)
    DataManager->>ApiClient: installApp(request)
    ApiClient->>AuthManager: generateAuthHeaders()
    AuthManager-->>ApiClient: headers
    ApiClient->>1PanelAPI: POST /apps/install
    1PanelAPI-->>ApiClient: Response
    ApiClient-->>DataManager: Installation status
    DataManager->>CacheManager: Update cache
    DataManager-->>UIManager: Installation status
    UIManager->>User: Show installation result
```

## 3. Sequence Diagram - User Login

```mermaid
sequenceDiagram
    participant User
    participant UIManager
    participant AuthManager
    participant ApiClient
    participant 1PanelAPI
    participant TokenStorage
    
    User->>UIManager: Enter credentials
    UIManager->>AuthManager: login(username, password)
    AuthManager->>ApiClient: POST /auth/login
    ApiClient->>1PanelAPI: POST /auth/login
    1PanelAPI-->>ApiClient: Token response
    ApiClient-->>AuthManager: Token data
    AuthManager->>TokenStorage: Save token
    TokenStorage-->>AuthManager: Save confirmation
    AuthManager-->>UIManager: Login success
    UIManager->>User: Navigate to dashboard
```

## 4. Sequence Diagram - Real-time Data Update

```mermaid
sequenceDiagram
    participant User
    participant UIManager
    participant DataManager
    participant WebSocketService
    participant 1PanelWebSocket
    
    User->>UIManager: Open dashboard
    UIManager->>DataManager: Load dashboard data
    DataManager->>WebSocketService: Connect
    WebSocketService->>1PanelWebSocket: WebSocket connection
    1PanelWebSocket-->>WebSocketService: Connection established
    WebSocketService->>1PanelWebSocket: Subscribe to system_status
    1PanelWebSocket-->>WebSocketService: System status data
    WebSocketService-->>DataManager: Update system status
    DataManager-->>UIManager: Update UI
    UIManager->>User: Display updated data
```

## 5. Sequence Diagram - File Upload

```mermaid
sequenceDiagram
    participant User
    participant UIManager
    participant DataManager
    participant ApiClient
    participant AuthManager
    participant 1PanelAPI
    
    User->>UIManager: Select file to upload
    UIManager->>DataManager: uploadFile(path, file)
    DataManager->>ApiClient: uploadFile(path, file)
    ApiClient->>AuthManager: generateAuthHeaders()
    AuthManager-->>ApiClient: headers
    ApiClient->>1PanelAPI: POST /files/upload (multipart)
    1PanelAPI-->>ApiClient: Upload progress
    ApiClient-->>DataManager: Upload progress
    DataManager-->>UIManager: Update progress
    UIManager->>User: Show upload progress
    1PanelAPI-->>ApiClient: Upload complete
    ApiClient-->>DataManager: Upload result
    DataManager-->>UIManager: Upload complete
    UIManager->>User: Show upload result
```

## 6. State Diagram - App Status

```mermaid
stateDiagram
    [*] --> Available
    Available --> Installing: Install
    Installing --> Installed: Success
    Installing --> Failed: Error
    Installed --> Updating: Update
    Updating --> Installed: Success
    Updating --> Failed: Error
    Installed --> Uninstalling: Uninstall
    Uninstalling --> Available: Success
    Failed --> Available: Retry
```

## 7. State Diagram - Container Status

```mermaid
stateDiagram
    [*] --> Created
    Created --> Running: Start
    Running --> Stopped: Stop
    Stopped --> Running: Start
    Running --> Restarting: Restart
    Restarting --> Running: Success
    Restarting --> Stopped: Error
    Running --> Paused: Pause
    Paused --> Running: Resume
    Created --> Deleted: Delete
    Stopped --> Deleted: Delete
    Paused --> Deleted: Delete
```

## 8. State Diagram - Website SSL Status

```mermaid
stateDiagram
    [*] --> Disabled
    Disabled --> Enabling: Enable SSL
    Enabling --> Enabled: Success
    Enabling --> Disabled: Error
    Enabled --> Disabling: Disable SSL
    Disabling --> Disabled: Success
    Enabled --> Renewing: Renew SSL
    Renewing --> Enabled: Success
    Renewing --> Disabled: Error
```

## 9. State Diagram - User Authentication

```mermaid
stateDiagram
    [*] --> LoggedOut
    LoggedOut --> LoggingIn: Login
    LoggingIn --> LoggedIn: Success
    LoggingIn --> LoggedOut: Failed
    LoggedIn --> Refreshing: Token Expired
    Refreshing --> LoggedIn: Success
    Refreshing --> LoggedOut: Failed
    LoggedIn --> LoggedOut: Logout
```

## 10. State Diagram - File Operation

```mermaid
stateDiagram
    [*] --> Idle
    Idle --> Uploading: Upload File
    Uploading --> Idle: Success
    Uploading --> Idle: Error
    Idle --> Downloading: Download File
    Downloading --> Idle: Success
    Downloading --> Idle: Error
    Idle --> Deleting: Delete File
    Deleting --> Idle: Success
    Deleting --> Idle: Error
```

## 11. State Diagram - Backup Operation

```mermaid
stateDiagram
    [*] --> Idle
    Idle --> Creating: Create Backup
    Creating --> Idle: Success
    Creating --> Idle: Error
    Idle --> Restoring: Restore Backup
    Restoring --> Idle: Success
    Restoring --> Idle: Error
    Idle --> Deleting: Delete Backup
    Deleting --> Idle: Success
    Deleting --> Idle: Error
```

## 12. Component Diagram - App Architecture

```mermaid
componentDiagram
    [Flutter App] as App
    [Auth Module] as Auth
    [API Module] as API
    [Data Module] as Data
    [UI Module] as UI
    [Cache Module] as Cache
    [WebSocket Module] as WS
    
    App --> Auth
    App --> API
    App --> Data
    App --> UI
    App --> Cache
    App --> WS
    
    Auth --> API : Provides auth headers
    API --> Data : Fetches data
    Data --> Cache : Stores/Retrieves data
    Data --> WS : Receives real-time updates
    UI --> Data : Displays data
    UI --> Auth : Manages user sessions
    
    subgraph Authentication
        Auth
    end
    
    subgraph Data Management
        Data
        Cache
    end
    
    subgraph Communication
        API
        WS
    end
    
    subgraph User Interface
        UI
    end
```

## 13. Component Diagram - API Integration

```mermaid
componentDiagram
    [Flutter App] as App
    [Dio Client] as Dio
    [Auth Interceptor] as AuthInterceptor
    [Error Handler] as ErrorHandler
    [Cache Manager] as CacheManager
    [1Panel API] as API
    
    App --> Dio
    Dio --> AuthInterceptor
    Dio --> ErrorHandler
    Dio --> CacheManager
    Dio --> API
    
    AuthInterceptor --> CacheManager : Gets token
    ErrorHandler --> App : Reports errors
    CacheManager --> Dio : Provides cached data
    
    subgraph HTTP Client
        Dio
        AuthInterceptor
        ErrorHandler
    end
    
    subgraph Data Layer
        CacheManager
    end
    
    subgraph External Service
        API
    end
```

## 14. Deployment Diagram - App Deployment

```mermaid
deploymentDiagram
    node [Mobile Device] {
        [Flutter App] as App
        [Local Storage] as Storage
        [Network Layer] as Network
    }
    
    node [1Panel Server] {
        [1Panel API] as ServerAPI
        [WebSocket Service] as WSService
        [Database] as DB
        [File System] as FS
    }
    
    App --> Storage : Stores token/cache
    App --> Network : Makes HTTP requests
    Network --> ServerAPI : Forwards requests
    Network --> WSService : Establishes WebSocket
    ServerAPI --> DB : Reads/Writes data
    ServerAPI --> FS : Manages files
    WSService --> App : Pushes real-time updates
```

## 15. Activity Diagram - User Login Flow

```mermaid
activityDiagram
    start
    :Open app;
    :Check stored token;
    if (Valid token?) then (yes)
        :Navigate to dashboard;
    else (no)
        :Show login screen;
        :Enter credentials;
        :Validate input;
        if (Valid input?) then (yes)
            :Send login request;
            if (Login success?) then (yes)
                :Store token;
                :Navigate to dashboard;
            else (no)
                :Show error message;
                :Return to login;
            endif
        else (no)
            :Show validation error;
            :Return to login;
        endif
    endif
    stop
```

## 16. Activity Diagram - App Installation Flow

```mermaid
activityDiagram
    start
    :Navigate to app store;
    :Select app to install;
    :Show app details;
    :Configure installation;
    :Confirm installation;
    :Send install request;
    :Show installation progress;
    if (Installation success?) then (yes)
        :Show success message;
        :Navigate to app management;
    else (no)
        :Show error message;
        :Return to app store;
    endif
    stop
```

## 17. Activity Diagram - File Upload Flow

```mermaid
activityDiagram
    start
    :Navigate to file manager;
    :Select directory;
    :Click upload button;
    :Select file(s);
    if (File size valid?) then (yes)
        :Start upload;
        :Show upload progress;
        if (Upload success?) then (yes)
            :Show success message;
            :Refresh file list;
        else (no)
            :Show error message;
        endif
    else (no)
        :Show size limit error;
    endif
    stop
```