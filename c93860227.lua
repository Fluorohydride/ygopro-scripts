--Necroquip Princess
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,s.ffilter1,s.ffilter2,1,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_ONFIELD+LOCATION_HAND,0,Duel.SendtoGrave,REASON_COST)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--equip or draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.tscon)
	e2:SetTarget(s.tstg)
	e2:SetOperation(s.tsop)
	c:RegisterEffect(e2)
end
function s.eqilter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0
end
function s.ffilter1(c,fc,sub,mg,sg)
	return c:GetEquipGroup():IsExists(s.eqilter,1,nil)
end
function s.ffilter2(c,fc,sub,mg,sg)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsRace(RACE_FIEND)
end
function s.tgfilter(c)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER)
end
function s.tscon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return r&REASON_COST~=0 and eg:IsExists(s.tgfilter,1,nil)
end
function s.eqfilter(c)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=eg:IsExists(s.eqfilter,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
	else
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function s.tsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if c:IsFaceup() and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local ec=eg:FilterSelect(tp,aux.NecroValleyFilter(s.eqfilter),1,1,nil):GetFirst()
			if not Duel.Equip(tp,ec,c) then return end
			--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetLabelObject(c)
			e1:SetValue(s.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(500)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e2)
		end
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
