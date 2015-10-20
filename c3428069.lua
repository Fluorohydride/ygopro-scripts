--Scripted by Ragna_Edge
--Buster Blader, the Destruction Swordmaster
function c3428069.initial_effect(c)
	--Code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(78193831)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3428069,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c3428069.eqcon)
	e2:SetTarget(c3428069.eqtg)
	e2:SetOperation(c3428069.eqop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3428069,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c3428069.descost)
	e3:SetTarget(c3428069.destg)
	e3:SetOperation(c3428069.desop)
	c:RegisterEffect(e3)
end
function c3428069.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsControler(1-tp) and c:IsLocation(LOCATION_GRAVE)
end
function c3428069.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3428069.cfilter,1,nil,tp)
end
function c3428069.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c3428069.cfilter(chkc,tp) end
	if chk==0 then return true end
	local g=eg:Filter(c3428069.cfilter,nil,tp)
	local tc
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tc=g:Select(tp,1,1,nil):GetFirst()
	else
		tc=g:GetFirst()
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c3428069.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c3428069.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c3428069.eqlimit(e,c)
	return e:GetOwner()==c
end
function c3428069.desfil1(c,ec,tp)
	return c:GetEquipTarget()==ec and Duel.IsExistingMatchingCard(c3428069.desfil2,tp,0,LOCATION_MZONE,1,nil,c:GetRace()) and c:IsAbleToGraveAsCost()
end
function c3428069.desfil2(c,rc)
	return c:IsRace(rc) and c:IsDestructable()
end
function c3428069.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3428069.desfil1,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c3428069.desfil1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e:GetHandler(),tp)
	e:SetLabel(g:GetFirst():GetRace())
	Duel.SendtoGrave(g,REASON_COST)
end
function c3428069.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c3428069.desfil2,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c3428069.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c3428069.desfil2,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.Destroy(g,REASON_EFFECT)
end
