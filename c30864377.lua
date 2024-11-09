--剣闘獣総監エーディトル
---@param c Card
function c30864377.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c30864377.matfilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_MZONE,0,aux.tdcfop(c))
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c30864377.splimit)
	c:RegisterEffect(e1)
	--cannot be fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--special summon (extra)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(30864377,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c30864377.esptg)
	e4:SetOperation(c30864377.espop)
	c:RegisterEffect(e4)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(30864377,4))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c30864377.spcost)
	e6:SetTarget(c30864377.sptg)
	e6:SetOperation(c30864377.spop)
	c:RegisterEffect(e6)
end
function c30864377.matfilter(c)
	return c:IsLevelAbove(5) and c:IsFusionSetCard(0x1019)
end
function c30864377.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c30864377.espfilter(c,e,tp)
	return c:IsSetCard(0x1019) and c:IsType(TYPE_FUSION) and not c:IsCode(30864377)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c30864377.esptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30864377.espfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c30864377.espop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c30864377.espfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c30864377.spcfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0x1019) and c:GetBattledGroupCount()>0
		and c:IsAbleToDeckOrExtraAsCost() and (ft>0 or c:GetSequence()<5)
end
function c30864377.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c30864377.spcfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c30864377.spcfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c30864377.spfilter(c,e,tp)
	return c:IsSetCard(0x1019) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30864377.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30864377.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c30864377.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c30864377.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)
		Duel.SpecialSummonComplete()
	end
end
