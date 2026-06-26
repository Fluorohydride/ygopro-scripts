--道化の一座『下稽古』
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,82159583)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Ritual Summon
	local e2=aux.AddRitualProcGreater2(c,s.filter,LOCATION_HAND,nil,nil,true)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	c:RegisterEffect(e2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,aux.TRUE,1,REASON_COST,true,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,aux.TRUE,1,1,REASON_COST,true,nil,tp)
	Duel.Release(g,REASON_COST)
end
function s.thfilter(c)
	return s.thfilter1(c) or s.thfilter2(c)
end
function s.thfilter1(c)
	return not c:IsCode(id) and c:IsSetCard(0x1dc) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thfilter2(c)
	return c:IsCode(82159583) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		return g:CheckSubGroup(aux.gffcheck,2,2,s.thfilter1,nil,s.thfilter2,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if not g:CheckSubGroup(aux.gffcheck,2,2,s.thfilter1,nil,s.thfilter2,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1=g:SelectSubGroup(tp,aux.gffcheck,false,2,2,s.thfilter1,nil,s.thfilter2,nil)
	if tg1:GetCount()==2 then
		Duel.SendtoHand(tg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg1)
	end
end
function s.filter(c,e,tp,chk)
	return c:IsSetCard(0x1dc) and c:IsType(TYPE_RITUAL) and (not chk or c~=e:GetHandler())
end
