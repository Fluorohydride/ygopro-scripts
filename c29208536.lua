--No.45 滅亡の予言者 クランブル・ロゴス
function c29208536.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2,nil,nil,99)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29208536,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c29208536.cost)
	e1:SetTarget(c29208536.target)
	e1:SetOperation(c29208536.operation)
	c:RegisterEffect(e1)
	--cannnot activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetCondition(c29208536.actcon)
	e3:SetValue(c29208536.aclimit)
	c:RegisterEffect(e3)
end
c29208536.xyz_number=45
function c29208536.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29208536.filter(c)
	return c:IsFaceup() and not c:IsDisabled() and not c:IsType(TYPE_NORMAL)
end
function c29208536.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c29208536.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c29208536.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c29208536.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c29208536.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e)
		and not tc:IsImmuneToEffect(e) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c29208536.rcon)
		tc:RegisterEffect(e1)
	end
end
function c29208536.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c29208536.actcon(e)
	return e:GetHandler():GetCardTargetCount()>0
end
function c29208536.aclimit(e,re,tp)
	local g=e:GetHandler():GetCardTarget()
	local cg={}
	local tc=g:GetFirst()
	while tc do
		table.insert(cg,tc:GetCode())
		tc=g:GetNext()
	end
	return re:GetHandler():IsCode(table.unpack(cg))
end
