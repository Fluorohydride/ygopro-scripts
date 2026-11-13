--原質の炉心溶融
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--add overlay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(s.ovcon)
	e3:SetTarget(s.ovtg)
	e3:SetOperation(s.ovop)
	c:RegisterEffect(e3)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>5 end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
end
function s.thfilter(c)
	return c:IsSetCard(0x160) and c:IsAbleToHand()
end
function s.xyzfilter(c)
	return c:IsFaceup() and c:IsRank(3)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dc==0 then return end
	if dc>6 then dc=6 end
	Duel.ConfirmDecktop(tp,dc)
	local g=Duel.GetDecktopGroup(tp,dc)
	local sd=true
	if g:IsExists(s.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,s.thfilter,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		if dc>1 then
			Duel.SortDecktop(tp,tp,dc-1)
		else
			sd=false
		end
	else Duel.SortDecktop(tp,tp,dc) end
	if sd then
		local rg=Group.CreateGroup()
		local xg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_MZONE,0,nil)
		if xg:GetCount()<1 then return end
		for tc in aux.Next(xg) do
			local hg=tc:GetOverlayGroup()
			if hg:GetCount()>0 then
				rg:Merge(hg)
			end
		end
		if rg:FilterCount(Card.IsAbleToHand,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			local thg=rg:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
			local sg=thg:Filter(Card.IsControler,nil,tp)
			if sg:GetCount()>0 then
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			end
			local og=thg:Filter(Card.IsControler,nil,1-tp)
			if og:GetCount()>0 then
				Duel.ConfirmCards(tp,og)
				Duel.ShuffleHand(1-tp)
			end
		end
	end
end
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==tp and re:IsActiveType(TYPE_MONSTER) and rc:IsType(TYPE_XYZ)
end
function s.matfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x160)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,1)
	if g:GetCount()==1 then
		local tc=g:GetFirst()
		Duel.DisableShuffleCheck()
		if Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_MZONE,0,1,nil) and tc:IsCanOverlay() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.Overlay(sg:GetFirst(),Group.FromCards(tc))
		else
			Duel.SendtoGrave(g,REASON_RULE)
		end
	end
end
