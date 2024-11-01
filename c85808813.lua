--タイム・ストリーム
---@param c Card
function c85808813.initial_effect(c)
	aux.AddCodeList(c,59419719)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(85808813,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c85808813.target)
	e1:SetOperation(c85808813.activate)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(85808813,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c85808813.spcost)
	e2:SetTarget(c85808813.sptg)
	e2:SetOperation(c85808813.spop)
	c:RegisterEffect(e2)
end
c85808813.fusion_effect=true
function c85808813.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x149) and c:IsType(TYPE_FUSION) and c:IsReleasableByEffect()
		and Duel.IsExistingMatchingCard(c85808813.ffilter,tp,LOCATION_EXTRA,0,1,nil,c:GetOriginalLevel(),e,tp,c)
end
function c85808813.ffilter(c,lv,e,tp,tc)
	return c:IsSetCard(0x149) and c:IsType(TYPE_FUSION) and c:GetOriginalLevel()==lv+2
		and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_FOSSIL_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c85808813.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x149) and c:IsType(TYPE_FUSION)
end
function c85808813.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsReleasableByEffect()
		and chkc:IsFaceup() and chkc:IsSetCard(0x149) and chkc:IsType(TYPE_FUSION) end
	if chk==0 then return Duel.IsExistingTarget(c85808813.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c85808813.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c85808813.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetOriginalLevel()
	if Duel.Release(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c85808813.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp,nil)
	if sg:GetCount()>0 then
		sg:GetFirst():SetMaterial(nil)
		Duel.SpecialSummon(sg,SUMMON_VALUE_FOSSIL_FUSION,tp,tp,false,false,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end
function c85808813.cfilter(c,e,tp)
	return c:IsSetCard(0x149) and c:IsType(TYPE_FUSION) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c85808813.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c85808813.spfilter(c,e,tp)
	return c:IsSetCard(0x149) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c85808813.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c85808813.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c85808813.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c85808813.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c85808813.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c85808813.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c85808813.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
