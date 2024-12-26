--沈黙狼－カルーポ
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--Equip Fadown
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Guess
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.guesstg)
	e3:SetOperation(s.guessop)
	c:RegisterEffect(e3)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if c:IsFaceup() and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and tc and tc:IsFacedown() and Duel.IsPlayerCanSSet(tp,tc) then
		Duel.DisableShuffleCheck()
		if tc:IsForbidden() then
			Duel.SendtoGrave(tc,REASON_RULE)
			return
		end
		if not Duel.Equip(tp,tc,c,false) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		--atk up
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.guesstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function s.eqfilter(c)
	return c:IsFacedown() and c:GetFlagEffect(id)~=0
end
function s.guessop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipGroup():Filter(s.eqfilter,nil):GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
		local op=Duel.AnnounceType(1-tp)
		if (op==0 and tc:GetOriginalType()&TYPE_MONSTER~=0)
			or (op==1 and tc:GetOriginalType()&TYPE_SPELL~=0)
			or (op==2 and tc:GetOriginalType()&TYPE_TRAP~=0)
			and c:IsAbleToGrave() then
			Duel.SendtoGrave(c,REASON_EFFECT)
		elseif (op==0 and tc:GetOriginalType()&TYPE_MONSTER==0)
			or (op==1 and tc:GetOriginalType()&TYPE_SPELL==0)
			or (op==2 and tc:GetOriginalType()&TYPE_TRAP==0) then
			local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
			if g:GetCount()==0 then return end
			local sg=g:RandomSelect(1-tp,1)
			if Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)>0 and c:IsAbleToHand() then
				Duel.SendtoHand(c,nil,REASON_EFFECT)
			end
		end
	end
end
