--彼岸の巡礼者 ダンテ
function c18386170.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c18386170.fscon)
	e1:SetOperation(c18386170.fsop)
	c:RegisterEffect(e1)
	--special summon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c18386170.tgval)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1)
	e4:SetCost(c18386170.drcost)
	e4:SetTarget(c18386170.drtg)
	e4:SetOperation(c18386170.drop)
	c:RegisterEffect(e4)
	--handes
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_HANDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCondition(c18386170.hdcon)
	e5:SetTarget(c18386170.hdtg)
	e5:SetOperation(c18386170.hdop)
	c:RegisterEffect(e5)
end
function c18386170.tgval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c18386170.cfilter(c)
	return c:IsSetCard(0xb1) and c:IsAbleToGraveAsCost()
end
function c18386170.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18386170.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c18386170.cfilter,1,1,REASON_COST,nil)
end
function c18386170.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c18386170.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c18386170.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (rp~=tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)) or c:IsReason(REASON_BATTLE)
end
function c18386170.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c18386170.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c18386170.ffilter(c,fc)
	return c:IsFusionSetCard(0xb1) and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc)
end
function c18386170.fselect(c,mg,sg,tp,fc)
	if sg:IsExists(Card.IsCode,1,nil,c:GetCode()) then return false end
	sg:AddCard(c)
	local res=false
	if sg:GetCount()==3 then
		res=Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0
	else
		res=mg:IsExists(c18386170.fselect,1,sg,mg,sg,tp,fc)
	end
	sg:RemoveCard(c)
	return res
end
function c18386170.fscon(e,g,gc,chkf)
	if g==nil then return true end
	local c=e:GetHandler()
	local tp=c:GetControler()
	local mg=g:Filter(c18386170.ffilter,nil,c)
	local sg=Group.CreateGroup()
	if gc then return c18386170.ffilter(gc,c) and c18386170.fselect(gc,mg,sg,tp,c) end
	return mg:IsExists(c18386170.fselect,1,sg,mg,sg,tp,c)
end
function c18386170.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local mg=eg:Filter(c18386170.ffilter,nil,c)
	local sg=Group.CreateGroup()
	if gc then sg:AddCard(gc) end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g=mg:FilterSelect(tp,c18386170.fselect,1,1,sg,mg,sg,tp,c)
		sg:Merge(g)
	until sg:GetCount()==3
	Duel.SetFusionMaterial(sg)
end
