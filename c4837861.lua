--機皇神龍トリスケリア
function c4837861.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c4837861.spcon)
	e2:SetTarget(c4837861.sptg)
	e2:SetOperation(c4837861.spop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4837861,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1)
	e3:SetTarget(c4837861.eqtg)
	e3:SetOperation(c4837861.eqop)
	c:RegisterEffect(e3)
	--attack thrice
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c4837861.pcon)
	e4:SetValue(2)
	c:RegisterEffect(e4)
end
function c4837861.spfilter(c)
	return c:IsSetCard(0x13) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c4837861.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c4837861.spfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=3
end
function c4837861.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c4837861.spfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	aux.GCheckAdditional=aux.dncheck
	local rg=g:SelectSubGroup(tp,aux.TRUE,true,3,3)
	aux.GCheckAdditional=nil
	if rg then
		rg:KeepAlive()
		e:SetLabelObject(rg)
		return true
	else return false end
end
function c4837861.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=e:GetLabelObject()
	Duel.Remove(rg,POS_FACEUP,REASON_SPSUMMON)
	rg:DeleteGroup()
end
function c4837861.eqfilter(c,tp)
	return not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c4837861.filter(c,tp)
	return c:IsFacedown() or c4837861.eqfilter(c,tp)
end
function c4837861.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0
		and g:IsExists(c4837861.filter,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,1-tp,LOCATION_EXTRA)
end
function c4837861.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g,true)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:FilterSelect(tp,c4837861.eqfilter,1,1,nil,tp)
	local tc=sg:GetFirst()
	if tc then
		if Duel.Equip(tp,tc,c) then
			local atk=tc:GetTextAttack()
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c4837861.eqlimit)
			tc:RegisterEffect(e1)
			if atk>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetValue(atk)
				tc:RegisterEffect(e2)
			end
		end
	end
	Duel.ShuffleExtra(1-tp)
end
function c4837861.eqlimit(e,c)
	return e:GetOwner()==c
end
function c4837861.xatkfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_SYNCHRO~=0
end
function c4837861.pcon(e)
	return e:GetHandler():GetEquipGroup():IsExists(c4837861.xatkfilter,1,nil)
end
