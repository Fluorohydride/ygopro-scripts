--Defense of the Temple
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,29762407,22082432)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		post_select_mat_opponent_location=LOCATION_MZONE,
		additional_fcheck=s.fcheck
	})
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.fusfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end

---@type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	-- Filter the group to get only the opponent’s Fusion Materials
	---@param c Card
	local mg_opponent=mg:Filter(function(c) return c:IsControler(1-tp) end,nil)
	-- If using an opponent’s monster, you must also use at least one monster mentioned "Temple of the Kings"  you control
	---@param c Card
	if #mg_opponent>0 and not mg_all:IsExists(function(c)
				return c:IsControler(tp) and aux.IsCodeListed(c,29762407)==true and c:IsOnField()
			end,1,nil) then
		return false
	end
	return true
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceupEx,Card.IsCode),tp,LOCATION_ONFIELD,0,1,nil,29762407)
end

function s.thfilter(c)
	return c:IsCode(22082432) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
