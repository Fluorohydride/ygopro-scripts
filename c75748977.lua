--XYZ－ハイパー・ドラゴン・キャノン
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,70860415,6355563,33744268,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.descon)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.spfilter(c,e,tp,fc)
	return aux.IsMaterialListCode(fc,c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.fselect(tg,tp,ec)
	return Duel.GetMZoneCount(tp,ec,tp)>=#tg
end
function s.ffilter(c,e,tp,ec)
	if not (c:IsType(TYPE_FUSION) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(8)) then return false end
	local tg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,c)
	return tg:CheckSubGroup(s.fselect,1,3,tp,ec)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local fc=Duel.SelectMatchingCard(tp,s.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c):GetFirst()
	Duel.ConfirmCards(1-tp,fc)
	e:SetLabelObject(fc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>3 then ft=3 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local fc=e:GetLabelObject()
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,fc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=mg:SelectSubGroup(tp,aux.TRUE,false,1,ft)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
