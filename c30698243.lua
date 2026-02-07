--スカーレッド・ハイパーノヴァ・ドラゴン
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,97489701)
	--material
	aux.AddSynchroMixProcedure(c,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),nil,nil,s.mfilter,4,99,s.syncheck)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(s.synlimit)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetTarget(s.retg)
	e5:SetOperation(s.reop)
	c:RegisterEffect(e5)
	--double tuner
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(21142671)
	c:RegisterEffect(e6)
end
s.material_type=TYPE_SYNCHRO
function s.synlimit(e,se,sp,st)
	return st&SUMMON_TYPE_SYNCHRO==SUMMON_TYPE_SYNCHRO and not se
end
function s.mfilter(e,c)
	return c:IsSynchroType(TYPE_TUNER) or not c:IsSynchroType(TYPE_TUNER) and c:IsSynchroType(TYPE_SYNCHRO)
end
function s.mgcheck(c,mg,syncard)
	local rg=mg-c
	if c:IsNotTuner(syncard) and c:IsSynchroType(TYPE_SYNCHRO) then
		return rg:FilterCount(Card.IsTuner,nil,syncard)==4
	else
		return false
	end
end
function s.syncheck(g,syncard)
	return g:IsExists(s.mgcheck,1,nil,g,syncard)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_TUNER)*500
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	sg:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function s.spfilter(c,e,tp)
	return c:IsCode(97489701) and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.rmfilter(c,tp)
	return c:GetPreviousControler()==tp
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ckg=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	if aux.NecroValleyNegateCheck(ckg) then return end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if c:IsRelateToChain() and c:IsAbleToRemove() then sg:AddCard(c) end
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		if og:GetCount()>0
			and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then
				tc:SetMaterial(nil)
				if Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
					tc:CompleteProcedure()
				end
			end
		end
	end
end
