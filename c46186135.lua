--神光の龍
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddMaterialCodeList(c,19959563,57774843)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(s.recost)
	e3:SetTarget(s.retg)
	e3:SetOperation(s.reop)
	c:RegisterEffect(e3)
	--discard deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.tgcon)
	e4:SetTarget(s.tgtg)
	e4:SetOperation(s.tgop)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(s.thcon)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
end
function s.fusfilter(c)
	return c:IsCode(19959563,57774843) and c:IsAbleToRemoveAsCost()
end
function s.fselect(g)
	return g:GetClassCount(Card.GetCode)==2 and g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local fg=Duel.GetMatchingGroup(s.fusfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return fg:CheckSubGroup(s.fselect,2,2)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local fg=Duel.GetMatchingGroup(s.fusfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=fg:SelectSubGroup(tp,s.fselect,false,2,2)
	c:SetMaterial(sg)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function s.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,c) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,aux.ExceptThisCard(e))
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,4)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,4,REASON_EFFECT)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():IsPreviousControler(tp)
end
function s.thfilter1(c)
	return c:IsFaceup() and c:IsCode(19959563) and c:IsAbleToHand()
end
function s.thfilter2(c)
	return c:IsFaceup() and c:IsCode(57774843) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_REMOVED)
end
function s.fselect2(g)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.GetMatchingGroup(s.thfilter1,tp,LOCATION_REMOVED,0,nil)
	local g2=Duel.GetMatchingGroup(s.thfilter2,tp,LOCATION_REMOVED,0,nil)
	if #g1>0 and #g2>0 then
		Duel.SendtoHand((g1+g2):SelectSubGroup(tp,s.fselect2,false,2,2),nil,REASON_EFFECT)
		local tg=Duel.GetOperatedGroup()
		Duel.ConfirmCards(1-tp,tg)
		if tg:FilterCount(s.spfilter,nil,e,tp)==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			for tc in aux.Next(tg) do
				Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
