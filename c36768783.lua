--星導竜アーミライル
---@param c Card
function c36768783.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2)
	c:EnableReviveLimit()
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36768783,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,36768783)
	e2:SetTarget(c36768783.sptg)
	e2:SetOperation(c36768783.spop)
	c:RegisterEffect(e2)
end
function c36768783.spfilter1(c,e,tp,zone,lg)
	local lv=c:GetOriginalLevel()
	return lv>0 and c:IsFaceup() and lg:IsContains(c) and Duel.IsExistingMatchingCard(c36768783.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp,lv,zone)
end
function c36768783.spfilter2(c,e,tp,lv,zone)
	return c:GetOriginalLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c36768783.spfilter_chkc(c,e,tp,lv,lg)
	return c:IsFaceup() and lg:IsContains(c) and c:GetOriginalLevel()==lv
end
function c36768783.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	local lg=c:GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c36768783.spfilter_chkc(chkc,e,tp,e:GetLabel(),lg) end
	if chk==0 then return Duel.IsExistingTarget(c36768783.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp,zone,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c36768783.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp,zone,lg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	e:SetLabel(g:GetFirst():GetOriginalLevel())
end
function c36768783.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local zone=c:GetLinkedZone(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c36768783.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc:GetOriginalLevel(),zone)
	local sc=g:GetFirst()
	if sc then
		if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
