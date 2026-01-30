//
//  DataMigrationTest.swift
//  MunKanji
//
//  테스트용: 마이그레이션이 데이터를 삭제하는지 확인
//

import Foundation
import SwiftData

class DataMigrationTest {

    /// 마이그레이션 전후 데이터 개수 비교
    static func testMigrationPreservesData(modelContext: ModelContext) {
        do {
            // 마이그레이션 전 카운트
            let beforeStudyLogCount = try modelContext.fetchCount(FetchDescriptor<StudyLog>())
            let beforeEumhunLogCount = try modelContext.fetchCount(FetchDescriptor<EumHunStudyLog>())

            print("📊 마이그레이션 전:")
            print("  - StudyLog: \(beforeStudyLogCount)개")
            print("  - EumHunStudyLog: \(beforeEumhunLogCount)개")

            // 마이그레이션 실행
            DataInitializer.migrateToNewKanjiDataIfNeeded(modelContext: modelContext)

            // 마이그레이션 후 카운트
            let afterStudyLogCount = try modelContext.fetchCount(FetchDescriptor<StudyLog>())
            let afterEumhunLogCount = try modelContext.fetchCount(FetchDescriptor<EumHunStudyLog>())

            print("📊 마이그레이션 후:")
            print("  - StudyLog: \(afterStudyLogCount)개")
            print("  - EumHunStudyLog: \(afterEumhunLogCount)개")

            // 검증
            if afterStudyLogCount < beforeStudyLogCount || afterEumhunLogCount < beforeEumhunLogCount {
                print("❌ 경고: 데이터가 삭제되었습니다!")
                print("   StudyLog 변화: \(beforeStudyLogCount) -> \(afterStudyLogCount)")
                print("   EumHunStudyLog 변화: \(beforeEumhunLogCount) -> \(afterEumhunLogCount)")
            } else {
                print("✅ 데이터 보존 확인: 학습 기록이 안전합니다")
            }

        } catch {
            print("❌ 테스트 실패: \(error)")
        }
    }

    /// 실제 StudyLog 상태값 비교 (더 정밀한 테스트)
    static func testStudyLogContentPreserved(modelContext: ModelContext) {
        do {
            // 마이그레이션 전 상태 스냅샷
            let beforeLogs = try modelContext.fetch(FetchDescriptor<StudyLog>())
            let beforeSnapshot = beforeLogs.map { ($0.kanjiID, $0.status.rawValue, $0.reviewCount) }

            print("📸 마이그레이션 전 스냅샷: \(beforeSnapshot.count)개")

            // 마이그레이션 실행
            DataInitializer.migrateToNewKanjiDataIfNeeded(modelContext: modelContext)

            // 마이그레이션 후 상태
            let afterLogs = try modelContext.fetch(FetchDescriptor<StudyLog>())
            let afterSnapshot = afterLogs.map { ($0.kanjiID, $0.status.rawValue, $0.reviewCount) }

            print("📸 마이그레이션 후 스냅샷: \(afterSnapshot.count)개")

            // 실제 학습 진행 상태 비교
            let changedCount = zip(beforeSnapshot, afterSnapshot).filter { $0 != $1 }.count

            if changedCount > 0 {
                print("❌ 경고: \(changedCount)개 학습 기록의 상태가 변경되었습니다!")
            } else {
                print("✅ 완벽: 모든 학습 기록이 동일하게 보존되었습니다")
            }

        } catch {
            print("❌ 테스트 실패: \(error)")
        }
    }
}
