你現在是這個專案的資深開發代理人，請協助我在現有專案中設計並實作一個「FHIR 測試資料產生器」。

### 背景與目標

我已經有現成的 TWIDIR FHIR converter，可將既有資料轉成符合 TWIDIR IG 的 FHIR Bundle。
我現在需要的是：建立一套「測試資料產生器」，不要重造一套新的 FHIR mapping 規則，而是要**盡可能沿用目前 converter 的轉換機制**，讓產出的 Bundle 仍然走既有 converter / validator 流程，以確保符合標準。

我要的不是單純複製真實資料，而是產生一批**非真實、可控、可大量生成、可重現**的測試資料，並且保有足夠的分布廣度，方便後續做：
- FHIR 匯入測試
- 查詢測試
- 統計測試
- UI / API 測試
- 壓力測試
- 邊界情境測試

---

### 額外前提

#### A. 院所代碼使用方式
我會提供一組「真實存在的醫療院所代碼」作為輸入資料來源。
這些院所代碼的用途是：
- 模擬資料分布於不同醫療院所
- 進一步模擬不同區域的報告分布
- 驗證系統在真實院所代碼格式下的表現

請注意：
- 可以使用我提供的院所代碼清單作為測試資料中的 organization / serviceProvider / performer / managingOrganization 等相關欄位來源
- 但**不得從這些院所代碼反推出任何真實病人資料**
- 不得補入真實世界可識別的院所詳細主檔內容，除非我另外明確提供
- 若需要區域資訊，請根據我提供的映射規則或額外提供的院所清單欄位來做，不要自行上網抓正式院所主檔
- 若未提供區域欄位，請設計「由我提供院所代碼對應區域映射表」的配置方式

#### B. 嚴格限制：資料只能留在本機
產生後的資料只能留在本機，不可以透過本專案功能上傳到真實伺服器。
這是硬性要求，請在設計與實作中強制保證：
- 不得自動呼叫任何 upload / import / push / submit / POST to remote server 的流程
- 不得串接正式 FHIR Server、外部 API、真實 TWIDIR endpoint、正式資料匯入端點
- 不得重用任何現有「上傳、送審、匯出到外部系統」的 service 作為預設流程
- 預設只能輸出到本機檔案系統，例如 JSON / NDJSON / bundle folder / local report
- 若專案已有 uploader、client、Feign、WebClient、RestTemplate、FHIR import service 等元件，請明確與測試資料產生器隔離
- 請加入防呆機制，避免開發者誤把產生器接到真實伺服器

請把「只能本機落地，不可遠端送出」當成設計中的最高優先安全限制之一。

---

### 核心要求

#### 1. 沿用既有 converter
- 不要另外手寫一整套 FHIR Bundle mapping
- 優先思考如何先產生「converter 可接受的來源資料模型 / DTO / entity」，再交給現有 converter 轉換
- 若 converter 有必要做最小幅度擴充，只能做「對測試資料生成友善」的非破壞性調整，不能破壞既有正式流程

#### 2. 確保符合 TWIDIR / FHIR 標準
- 產生器最終輸出應該透過既有 converter 產出 Bundle
- 產生出的 Bundle 應可接既有 validator / quality validator 驗證
- 若專案內已有 FHIR quality validator、FHIR server service、test_data 結構或相關測試模式，請優先沿用既有模式
- 驗證流程僅限本機執行，不得依賴遠端正式服務

#### 3. 測試資料必須與真實資料明確區隔
請設計明確的「假資料識別策略」，避免與真實資料混淆，例如：
- 病人識別碼命名規則
- 測試姓名規則
- 測試用 identifier system / namespace
- metadata tag 區隔
- 測試批次編號
- environment prefix（如 DEV / SIT / LOCAL）
- bundle identifier / accession / report id 命名規則

注意：
- 即使院所代碼使用真實代碼，整體資料仍必須清楚可辨識為「測試資料」
- 病人、報告、就醫、檢驗結果等不得看起來像真實正式資料
- 要做到「院所代碼真實，但病人與事件內容是合成測試資料」

#### 4. 測試資料要有足夠廣度
這是本需求的重點，請把資料分布策略設計完整，至少涵蓋：

- **時間區間要夠廣**
  - 不只近期資料
  - 應可涵蓋多年、多月份、不同季節、不同日期密度
  - 可模擬尖峰日、平峰日、節假日附近分布
  - 可支援可配置的起訖年/月/日與資料密度

- **病人分布要夠廣**
  - 不要集中在少數病人
  - 要能控制病人人數、每位病人的就醫/檢驗次數分布
  - 要能模擬：
    - 單次檢驗病人
    - 多次追蹤病人
    - 高頻檢驗病人
    - 不同年齡層 / 性別 / 身分特徵的分布
  - 同時要避免資料看起來像直接拷貝真人

- **醫療院所分布要夠廣（以我提供的醫療院所代碼分）**
  - 要能控制院所數量
  - 要能從我提供的院所清單中抽樣或加權分配
  - 要能模擬不同院所資料量差異
  - 例如：
    - 少數大型院所高量
    - 多數小型院所低量
    - 跨區域分散
  - 若我有提供院所代碼對應區域資料，請一併納入分布策略
  - 若沒有提供，請先預留 mapping config 機制，不要自行假設正式主檔

#### 5. 支援多樣情境與邊界案例
除了正常資料，也請一併考慮產生以下情境：
- 必填欄位完整的標準案例
- 欄位組合差異案例
- 單一病人多筆檢驗
- 多病人單日大量資料
- 不同院所同檢驗項目
- 同病人跨時間區間資料
- 稀疏資料與密集資料混合
- 可選欄位有值 / 無值兩種情況
- 合理但多樣的檢驗結果分布
- 若規格允許，加入少量 edge cases 供驗證測試使用

但注意：
- 不要故意產出明顯違反 IG 的非法資料，除非是明確規劃為「負向測試模式」
- 正向資料與負向資料模式要分開設計

---

### 你要完成的工作

請直接輸出以下內容：

#### A. 整體設計方案
請說明你打算如何在目前專案中落地這個測試資料產生器，包括：
- 放在哪個 package / module
- 如何與既有 converter 串接
- 如何與 validator 串接
- 如何避免汙染正式流程
- 如何與 uploader / remote client / import service 完全隔離
- 如何強制只能輸出本機檔案
- 如何讓未來維護者容易擴充

#### B. 產生流程設計
請描述完整流程，例如：
1. 讀取 generation config
2. 讀取我提供的院所代碼清單與區域映射
3. 產生測試用來源資料模型
4. 將來源資料餵給既有 converter
5. 本機執行 validator
6. 輸出 JSON 檔案 / NDJSON / 批次資料夾
7. 輸出統計摘要
8. 全流程不得呼叫任何遠端 API

#### C. 資料模型與設定設計
請設計一份可配置的 generation config，至少包含：
- 總病人人數
- 每病人平均事件數
- 時間範圍
- 院所清單輸入路徑
- 院所區域映射輸入路徑
- 院所分布權重
- 檢驗項目分布
- 結果值分布
- 正向 / 負向測試模式
- random seed（確保可重現）
- 單次輸出筆數或批次大小
- 輸出路徑
- local-only safety flag
- 禁止 remote upload 開關，且預設為禁止

請給我建議的 Java class / record / enum 設計。

#### D. 假資料策略
請明確定義：
- 病人 ID 規則
- 姓名規則
- 測試生日 / 性別 / 識別欄位規則
- 院所代碼使用規則
- 檢驗單號 / Bundle identifier 規則
- metadata tag / profile / identifier system 的測試區隔策略
- 如何一眼辨識這是測試資料

請特別注意：
- 院所代碼可為真實代碼
- 但病人、事件、報告、識別碼都必須是測試生成，且具明確測試前綴或命名空間

#### E. 分布策略
請具體設計：
- 時間分布策略
- 病人事件分布策略
- 院所權重分布策略（根據我提供的院所代碼）
- 區域分布策略（根據我提供的區域映射）
- 檢驗項目分布策略
- 結果值分布策略

請不要只講概念，要給出可以實作的策略，例如：
- uniform / weighted / poisson / long-tail / configurable buckets
- 哪些欄位適合隨機，哪些欄位必須一致
- 哪些關聯要保持穩定（同病人、多次事件）

#### F. 本機安全限制設計
請明確設計並說明：
- 如何避免 generator 誤呼叫遠端 server client
- 是否要獨立 module / profile / package
- 是否要禁止注入 uploader bean
- 是否要在 runtime 啟動時檢查 URL / endpoint / profile
- 是否要在測試資料模式下直接封鎖 HTTP client
- 是否要在 CI / local profile 加入 guardrail
- 如何讓「只能本機輸出」成為可驗證的規則，而不是口頭約定

#### G. 實作計畫
請列出分階段實作步驟，例如：
- Phase 1：最小可行版本
- Phase 2：分布控制
- Phase 3：本機安全限制與 guardrail
- Phase 4：負向測試模式
- Phase 5：統計摘要與報表輸出

每一階段請標示：
- 目的
- 修改檔案
- 主要 class
- 驗收方式

#### H. 程式骨架
請直接提供可落地的程式骨架，不要只給概念。
至少包含：
- generator 主服務
- config 類別
- fake data factory
- distribution strategy 介面
- organization code provider
- region mapping provider
- converter adapter
- local validator runner
- local file writer
- safety guard
- summary reporter
- 測試類別骨架

請依照目前專案風格使用 Java / Spring Boot / Gradle 慣例。

#### I. 測試策略
請提供：
- 單元測試
- 整合測試
- golden file test
- seed 固定重現測試
- 統計分布合理性測試
- local-only guard 測試
- 確認不會呼叫 remote client 的測試
- validator 通過測試

#### J. 驗收標準
請定義一組可操作的驗收標準，例如：
- 指定 seed 可重現相同輸出
- 指定 1000 筆資料中，不少於多少病人、多少院所
- 時間涵蓋至少多少月 / 年
- Bundle validator 通過率
- 測試資料命名規則符合率
- 所有輸出皆落於本機指定目錄
- 不存在任何 remote upload / remote POST / external push 呼叫
- local-only guard 測試必須通過

---

### 限制與原則

- 優先重用現有 converter、validator、test 結構，不要另起爐灶
- 不要破壞正式上傳流程
- 但要與正式上傳能力完全隔離
- 不要把測試資料生成邏輯塞進 controller
- 請維持清楚的 service / generator / strategy 分層
- 若需抽象化，請以「未來可新增更多資料型態或 profile」為前提
- 若專案中已有代表性 service、validator、test pattern，請比照其風格
- 先以可維護、可驗證、可重現為主，再追求複雜度
- 對於院所代碼，僅使用我提供的清單，不要自行擴充正式主檔資料
- 對於網路行為，預設一律禁止，除非我明確另行要求
- 若有任何不確定之處，請以「最小侵入、最大重用、禁止遠端傳輸」為決策原則

---

### 輸出格式要求

請用以下結構輸出，不要省略：

1. 設計摘要
2. 建議目錄與類別結構
3. 產生流程
4. 設定模型設計
5. 假資料識別策略
6. 分布策略設計
7. 本機安全限制設計
8. 分階段實作計畫
9. Java 程式骨架
10. 測試策略
11. 驗收標準
12. 風險與後續建議

請直接給出可進入實作的內容，不要只停留在架構討論。